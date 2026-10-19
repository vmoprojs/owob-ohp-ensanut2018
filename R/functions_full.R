
# Portable orchestration only. Scientific algorithms reside in minimally adapted D/K/L modules.
run_full <- function() {
 root <- normalizePath(getwd()); input <- rd('data/input_manifest.csv')
 input_paths <- setNames(file.path(root,'data/raw',input$expected_filename),input$logical_name)
 stopifnot(all(file.exists(input_paths)),all(vapply(input_paths,sha,'')==input$sha256))
 stopifnot(requireNamespace('survey',quietly=TRUE),requireNamespace('haven',quietly=TRUE),requireNamespace('ade4',quietly=TRUE))
 b <- readRDS(input_paths[['PAIRED_MODEL_CONTRACT']]); base <- readRDS(input_paths[['ADJUDICATED_ANTHROPOMETRY']])
 work <- file.path(root,'private/upstream');dir.create(work,recursive=TRUE,showWarnings=FALSE)
 for(dn in c('config','outputs/qa','data/private','docs','tmp'))dir.create(file.path(work,dn),recursive=TRUE,showWarnings=FALSE)
 old <- getwd();on.exit(setwd(old));setwd(work)
 SAV<-input_paths[['SAV']];F4<-input_paths[['F4']];F1<-input_paths[['F1']];HH<-input_paths[['F1_HOUSEHOLD']]
 clean<-function(d)as.data.frame(lapply(d,function(x)haven::zap_labels(haven::zap_missing(x))),check.names=FALSE)
 wc<-function(x,n,dir='outputs/qa'){write.csv(x,file.path(dir,n),row.names=FALSE,na='',fileEncoding='UTF-8')}
 savepriv<-function(x,n)saveRDS(x,file.path('data/private',n),version=3)
 priv<-function(n)readRDS(file.path('data/private',n))
 verify_sources<-function()stopifnot(all(vapply(input_paths,sha,'')==input$sha256))
 freeze_csv<-function(x,p)write.csv(x,p,row.names=FALSE,na='',fileEncoding='UTF-8')
 dictionary<-function(d)do.call(rbind,lapply(names(d),function(n){x<-d[[n]];l<-attr(x,'labels');data.frame(variable=n,label=if(is.null(attr(x,'label')))''else attr(x,'label'),codes=if(is.null(l))''else paste(paste(l,names(l),sep='='),collapse=' | '),type=typeof(x))}))
 newblock<-function(id,scope,reason,action)stop(paste(id,scope,reason,action),call.=FALSE)
 write.csv(rd(file.path(root,'config/SES_ITEMS.csv')),'config/SES_ITEMS_FROZEN.csv',row.names=FALSE)
 writeLines('Immutable active-item contract; see repository methods.','docs/OWOB01D_NEW_SES_MCA_METHOD.md')
 freeze_csv(data.frame(path='config/SES_ITEMS_FROZEN.csv',sha256=sha('config/SES_ITEMS_FROZEN.csv')),'config/PROTOCOL_FREEZE.csv')
 writeLines('REPRODUCTION_ONLY','config/CREATED_AT.txt')
 for(module_file in c('functions_prepare.R','functions_ses.R','functions_design.R')){
  log<-capture.output(sys.source(file.path(root,'R',module_file),envir=environment()));writeLines(log,paste0('outputs/qa/',module_file,'.log'))
 }
 original_frame<-priv('analysis_frame.rds')
 check<-vapply(names(b$d_original),function(n)isTRUE(all.equal(original_frame[[n]],b$d_original[[n]],tolerance=1e-12,check.attributes=FALSE)),TRUE)
 stopifnot(all(check))
 # K-S2 only: official F1 T7 measurements, exact measurement age and independently verified reference.
 a<-base$inputs;wgt<-inec_pair_mean(a$f1_s7_4_1_F1,a$f1_s7_4_2_F1,a$f1_s7_4_3_F1);hgt<-inec_pair_mean(a$f1_s7_6_1_F1,a$f1_s7_6_2_F1,a$f1_s7_6_3_F1)
 stopifnot(!any(wgt$required_third_missing|hgt$required_third_missing),!any(a$recumbent_data_present))
 z<-who_z_independent(wgt$value/(hgt$value/100)^2,a$sex_sav,as.numeric(a$measure_date-a$dob_adjudicated)/30.4375,base$reference)
 catS<-category_z(z);j<-match(b$S2$id_per,a$id_per)
 stopifnot(!anyNA(j),all(is.finite(z)),identical(catS[j],b$S2$category),max(abs(z[j]-b$S2$Z))<=1e-10)
 d<-original_frame;d$OWOBL_NUTRITION_S2<-factor(catS[match(d$id_per,a$id_per)],levels=c('Healthy','Underweight','Overweight','Obesity'))
 validate_frame(d);stopifnot(isTRUE(all.equal(d,b$dL,tolerance=1e-12,check.attributes=FALSE)))
 full<-with_policy('fail',FALSE,survey::svydesign(ids=~upm,strata=~estrato,weights=~fexp,data=d,nest=TRUE))
 stopifnot(survey::degf(full)==survey::degf(b$full),isTRUE(all.equal(as.numeric(stats::weights(full)),as.numeric(stats::weights(b$full)),tolerance=0)))
 b$full<-full;b$dL<-d;setwd(root)
 # Reuse the exact L model engine. Portable path adapter exposes only its frozen registry/prefit gates.
 op<-function(q){if(q=='protocol/OWOB01L_MODEL_REGISTRY_FROZEN.csv')file.path(root,'config/MODEL_REGISTRY.csv')else if(q=='outputs/qa/MODEL_ESTIMABILITY_PREFIT.csv')file.path(root,'config/MODEL_ESTIMABILITY_PREFIT.csv')else file.path(root,q)}
 TAG<-'WHO2007_S2_PRIMARY_D04_APPROVED; oedema=n assumed, not clinically verified'
 .fitlog<-new.env();.fitlog$events<-list();sys.source(file.path(root,'R/functions_models.R'),envir=environment())
 reg<-rd('config/MODEL_REGISTRY.csv');out<-run_registry(reg,b,run='independent_compendium_replay')
 var<-run_registry(reg[reg$analysis_branch=='PRIMARY',],b,run='variance_replay',variance=TRUE)
 stopifnot(nrow(out$blocks)==0,nrow(var$blocks)==0,nrow(out$diagnostics)==58,nrow(var$diagnostics)==40)
 saveRDS(list(results=out$results,tests=out$tests,variance=var$results,diagnostics=rbind(out$diagnostics,var$diagnostics)),file.path(root,'private/FULL_REPLAY_AGGREGATES.rds'))
 # All coefficients and joint tests, not just selected significant results, must match frozen L.
 frozen<-rd('data/derived_public/S3_S2_ALL_MODELS_FROZEN_L.csv')
 key<-function(x)paste(x$model_id,x$arm,x$term,sep='::')
 ii<-match(key(out$results),key(frozen));stopifnot(!anyNA(ii),nrow(out$results)==nrow(frozen))
 q<-lapply(c('beta','SE','OR','CI_low','CI_high','p'),function(n){err<-max(abs(out$results[[n]]-frozen[[n]][ii]));data.frame(check=paste0('ALL_COEFFICIENTS_',n),max_abs_error=err,tolerance=1e-9,status=if(err<=1e-9)'PASS'else'FAIL')})
 tf<-rd('data/derived_public/S9_S2_GLOBAL_TESTS_FROZEN_L.csv');ti<-rd('data/derived_public/S9B_INTERACTION_FROZEN_L.csv');ti<-ti[ti$row_type=='GLOBAL_TEST' & ti$test=='nutrition_by_sex' & ti$exposure=='S2_L',];tf<-rbind(tf[c('model_id','arm','test','p')],ti[c('model_id','arm','test','p')]);keyt<-function(x)paste(x$model_id,x$arm,x$test,sep='::');jj<-match(keyt(out$tests),keyt(tf));stopifnot(!anyNA(jj))
 err<-max(abs(out$tests$p-tf$p[jj]));q[[length(q)+1]]<-data.frame(check='ALL_JOINT_TESTS',max_abs_error=err,tolerance=1e-9,status=if(err<=1e-9)'PASS'else'FAIL')
 vf<-rd('data/derived_public/S10_S2_VARIANCE_POLICY_FROZEN_L.csv');keyv<-function(x)paste(x$model_id,x$policy,x$term,sep='::');jj<-match(keyv(var$results),keyv(vf));stopifnot(!anyNA(jj));for(n in c('beta','SE','OR','CI_low','CI_high','p')){err<-max(abs(var$results[[n]]-vf[[n]][jj]));q[[length(q)+1]]<-data.frame(check=paste0('VARIANCE_SENSITIVITY_',n),max_abs_error=err,tolerance=1e-9,status=if(err<=1e-9)'PASS'else'FAIL')}
 qa<-do.call(rbind,q);stopifnot(all(qa$status=='PASS'))
 write.csv(qa,'results/checkpoints/LOCAL_FULL_QA.csv',row.names=FALSE)
 saveRDS(list(results=out$results,tests=out$tests,variance=var$results,diagnostics=rbind(out$diagnostics,var$diagnostics)),file.path(root,'private/FULL_REPLAY_AGGREGATES.rds'))
 message('FULL PASS: outcomes, MCA, S2, F4 design, 58 paired fits and 40 variance fits; nonredistributed inputs required.')
 invisible(qa)
}

