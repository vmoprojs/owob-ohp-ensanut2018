# New S2 fits only. Never source or execute the frozen D model runner.
compact_fit<-function(fit){list(coefficients=coef(fit),vcov=vcov(fit),rank=fit$rank,df_residual=fit$df.residual,n=nobs(fit),formula=paste(deparse(formula(fit)),collapse=' '),model_matrix_hash=oh(model.matrix(fit)),response_hash=oh(as.numeric(model.response(model.frame(fit)))),converged=fit$converged)}
verify_model_freeze<-function(){m<-rd(op('inputs_metadata/MODEL_SOURCE_FREEZE.csv'));stopifnot(all(vapply(file.path(ROOT,m$path),sha,'')==m$sha256));invisible(TRUE)}
reference_L<-function(term){if(grepl('OWOBL_NUTRITION_S2',term,fixed=TRUE))'Healthy(S2)'else if(grepl('^sexo',term))'Female'else if(grepl('^area',term))'Urban'else if(grepl('^etnia',term))'MestizaOtra'else if(grepl('SES_MCA',term))'High'else if(grepl('edadanios',term))'continuous_original_years'else'not_applicable'}
fit_candidate<-function(r,b,arm='glm',policy='fail',adjust_domain=FALSE,run='initial'){
 reg<-rd(op('protocol/OWOB01L_MODEL_REGISTRY_FROZEN.csv'));registered<-reg[reg$model_id==r$model_id,]
 stopifnot(nrow(registered)==1,identical(registered$formula_S2,r$formula_S2),grepl('OWOBL_NUTRITION_S2',r$formula_S2,fixed=TRUE),!grepl('OWOBNEW_NUTRITION',r$formula_S2,fixed=TRUE),policy%in%c('fail','adjust','average'),arm%in%c('glm','svyglm'))
 mask<-b$masks[[r$model_id]]$mask;dd<-subset(b$full,mask);dat<-dd$variables;f<-as.formula(r$formula_S2);warn<-character();warnings_handler<-function(w){warn<<-c(warn,conditionMessage(w));invokeRestart('muffleWarning')}
 .fitlog$events[[length(.fitlog$events)+1]]<-data.frame(run=run,model_id=r$model_id,branch=r$analysis_branch,arm=arm,policy=if(arm=='glm')'unweighted'else paste(policy,adjust_domain,sep='/'),exposure=TAG)
 fit<-tryCatch(withCallingHandlers(with_policy(policy,adjust_domain,{if(arm=='glm')stats::glm(f,data=dat,family=binomial(),na.action=na.fail,model=TRUE,x=TRUE,y=TRUE)else survey::svyglm(f,design=dd,family=quasibinomial(),na.action=na.fail,model=TRUE,x=TRUE,y=TRUE)}),warning=warnings_handler),error=function(e)e)
 if(inherits(fit,'error'))return(list(status='BLOCKED_MODEL_FIT',error=conditionMessage(fit),warnings=warn))
 mf<-model.frame(fit);ids<-as.character(dat$id_per[match(rownames(mf),rownames(dat))]);same<-identical(ids,as.character(dat$id_per))&&oh(ids)==b$masks[[r$model_id]]$ordered_ids_hash&&identical(as.numeric(model.response(mf)),as.numeric(dat[[r$outcome_definition]]))
 beta<-coef(fit);se<-sqrt(diag(vcov(fit)));df<-if(arm=='svyglm')fit$df.residual else NA_real_
 good<-same&&fit$converged&&all(is.finite(c(beta,se)))&&all(se>0)&all(abs(beta)<=20)&&all(se<=10)&&(!is.finite(df)||df>0)
 if(arm=='svyglm')good<-good&&is.finite(df)&&df>0
 if(!good)return(list(status='BLOCKED_MODEL_ESTIMABILITY_OR_PAIR_IDENTITY',warnings=warn,fit=fit))
 q<-b$sampleqa_D[b$sampleqa_D$model_id==r$model_id,];crit<-if(arm=='glm')qnorm(.975)else qt(.975,df);p<-if(arm=='glm')2*pnorm(-abs(beta/se))else 2*pt(-abs(beta/se),df)
 out<-data.frame(model_id=r$model_id,analysis_branch=r$analysis_branch,domain=r$domain,outcome_definition=r$outcome_definition,adjustment=r$adjustment,arm=arm,term=names(beta),reference=vapply(names(beta),reference_L,''),beta=unname(beta),SE=unname(se),OR=exp(unname(beta)),CI_low=exp(unname(beta)-crit*unname(se)),CI_high=exp(unname(beta)+crit*unname(se)),p=unname(p),n_complete=nrow(dat),n_unweighted=nrow(dat),n_psu=q$n_psu,n_strata=q$n_strata,design_df=survey::degf(dd),residual_design_df=if(arm=='glm')NA_real_ else df,weight_sum=sum(dat$fexp),CI_method=if(arm=='glm')'Wald-normal95%'else'Wald-t95%_residual_design_df',policy=if(arm=='glm')'unweighted'else paste(policy,adjust_domain,sep='/'),exposure_status=TAG,QA_status='PASS')
 ts<-list();for(t in if(r$interaction)c('nutrition_main','nutrition_by_sex')else'nutrition_main'){
  ix<-grepl('^OWOBL_NUTRITION_S2',names(beta))&if(t=='nutrition_by_sex')grepl(':sexo',names(beta),fixed=TRUE)else!grepl(':',names(beta),fixed=TRUE)
  tf<-if(t=='nutrition_by_sex')~OWOBL_NUTRITION_S2:sexo else ~OWOBL_NUTRITION_S2
  if(arm=='glm'){stat<-as.numeric(crossprod(beta[ix],solve(vcov(fit)[ix,ix,drop=FALSE],beta[ix])));nu<-sum(ix);pv<-pchisq(stat,nu,lower.tail=FALSE);den<-NA_real_;method<-'Wald_chisq'}else{tt<-with_policy(policy,adjust_domain,survey::regTermTest(fit,tf,method='Wald',df=df));stat<-as.numeric(tt$Ftest);nu<-as.numeric(tt$df);den<-df;pv<-as.numeric(tt$p);method<-'Survey_Wald_F'}
  stopifnot(is.finite(stat),is.finite(pv),nu==3,pv>=0,pv<=1)
  ts[[t]]<-data.frame(model_id=r$model_id,analysis_branch=r$analysis_branch,domain=r$domain,arm=arm,test=t,statistic=stat,num_df=nu,den_df=den,p=pv,method=method,policy=if(arm=='glm')'unweighted'else paste(policy,adjust_domain,sep='/'),exposure_status=TAG,status='PASS')
 }
 diag<-data.frame(model_id=r$model_id,branch=r$analysis_branch,arm=arm,policy=if(arm=='glm')'unweighted'else paste(policy,adjust_domain,sep='/'),n=nrow(mf),converged=fit$converged,rank=fit$rank,columns=length(beta),aliases=anyNA(beta),finite_coefficients=all(is.finite(beta)),positive_finite_SE=all(is.finite(se)&se>0),positive_survey_df=if(arm=='svyglm')df>0 else TRUE,ordered_ids_match=same,warning_count=length(unique(warn)),status='PASS')
 list(status='PASS',results=out,tests=do.call(rbind,ts),diagnostics=diag,warnings=warn,fit=fit)
}
run_registry<-function(reg,b,run='initial',variance=FALSE){
 pre<-rd(op('outputs/qa/MODEL_ESTIMABILITY_PREFIT.csv'));results<-tests<-diagnostics<-fits<-warnings<-blocks<-list()
 for(i in seq_len(nrow(reg))){r<-reg[i,];q<-pre[pre$model_id==r$model_id,];if(nrow(q)!=1||q$status!='PASS'){blocks[[r$model_id]]<-data.frame(model_id=r$model_id,stage='PREFIT',reason=if(nrow(q))q$status else'NO_PREFIT_GATE');next}
  if(!variance){z<-list();for(arm in c('glm','svyglm'))z[[arm]]<-fit_candidate(r,b,arm,run=run)
   if(all(vapply(z,function(x)x$status=='PASS',TRUE))){u<-z$glm$fit;w<-z$svyglm$fit;pair<-identical(rownames(model.frame(u)),rownames(model.frame(w)))&&isTRUE(all.equal(model.matrix(u),model.matrix(w),check.attributes=FALSE))&&identical(as.numeric(model.response(model.frame(u))),as.numeric(model.response(model.frame(w))))
    if(!pair){blocks[[r$model_id]]<-data.frame(model_id=r$model_id,stage='POSTFIT',reason='BLOCKED_NOT_SAME_EFFECTIVE_SAMPLE');next}
    for(arm in names(z)){zz<-z[[arm]];results[[length(results)+1]]<-zz$results;tests[[length(tests)+1]]<-zz$tests;diagnostics[[length(diagnostics)+1]]<-zz$diagnostics;fits[[paste(r$model_id,arm,sep='::')]]<-compact_fit(zz$fit);warnings[[paste(r$model_id,arm,sep='::')]]<-zz$warnings}
   }else blocks[[r$model_id]]<-data.frame(model_id=r$model_id,stage='POSTFIT',reason=paste(vapply(z,function(x)x$status,''),collapse=';'))
  }else for(pol in c('adjust','average')){zz<-fit_candidate(r,b,'svyglm',pol,TRUE,run);if(zz$status=='PASS'){results[[length(results)+1]]<-zz$results;tests[[length(tests)+1]]<-zz$tests;diagnostics[[length(diagnostics)+1]]<-zz$diagnostics;fits[[paste(r$model_id,pol,sep='::')]]<-compact_fit(zz$fit);warnings[[paste(r$model_id,pol,sep='::')]]<-zz$warnings}else blocks[[paste(r$model_id,pol)]]<-data.frame(model_id=r$model_id,stage=pol,reason=zz$status)}
  cat(run,if(variance)'VARIANCE'else r$analysis_branch,i,'/',nrow(reg),r$model_id,'completed\n');flush.console()
 }
 bind<-function(x)if(length(x))do.call(rbind,x)else data.frame()
 list(results=bind(results),tests=bind(tests),diagnostics=bind(diagnostics),fits=fits,warnings=warnings,blocks=bind(blocks))
}
