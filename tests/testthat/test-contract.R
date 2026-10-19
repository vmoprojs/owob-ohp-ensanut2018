withr::local_dir(normalizePath('../..'))

testthat::test_that('input manifest schema is explicit and no raw files are shipped',{
 m<-rd('data/input_manifest.csv');testthat::expect_true(all(c('logical_name','expected_filename','source_url','sha256','required_for_full_mode','redistributed')%in%names(m)));testthat::expect_true(all(nchar(m$sha256)==64));testthat::expect_false(any(m$redistributed));testthat::expect_true(all(c('data/raw/*','private/')%in%readLines('.gitignore')))
})
testthat::test_that('OHRP6 handles unknown responses without recoding to no',{
 x<-rbind(rep(2,6),c(1,2,2,2,NA,2),c(2,2,2,NA,2,2),rep(NA,6));testthat::expect_equal(ORitems(x),c(0,1,NA,NA))
})
testthat::test_that('WHO S2 uses strict full-precision boundaries',{
 z<-c(-2-1e-10,-2,1,1+1e-10,2,2+1e-10,NA);testthat::expect_identical(category_z(z),c('Underweight','Healthy','Healthy','Overweight','Overweight','Obesity',NA_character_));testthat::expect_error(same_lengths(1,1:2))
})
testthat::test_that('frame schema rejects missing design, duplicate keys and invalid factors', {
 n<-23621; pivot<-seq_len(n)<=19750; dn<-c(rep('children',11319),rep('adolescents',8431),rep(NA_character_,3871)); lev<-c('Healthy','Underweight','Overweight','Obesity')
 d<-data.frame(id_per=sprintf('synthetic-%05d',seq_len(n)),upm='synthetic-PSU',estrato='synthetic-stratum',fexp=1,IN_OWOB_PIVOT=pivot,OWOBNEW_DOMAIN=dn,sexo=factor(rep('Female',n),levels=c('Female','Male')),OWOBNEW_OHRP6=0,OWOBNEW_SES_MCA_v1=factor(rep('High',n),levels=c('High','Medium','Low')))
 d$OWOBNEW_NUTRITION<-factor(ifelse(pivot,'Healthy',NA),levels=lev);d$OWOBL_NUTRITION_S2<-d$OWOBNEW_NUTRITION;d$OWOBL_NUTRITION_S2[1:1201]<-'Overweight'
 testthat::expect_true(validate_frame(d));bad<-d;bad$id_per[2]<-bad$id_per[1];testthat::expect_error(validate_frame(bad));testthat::expect_error(validate_frame(d[setdiff(names(d),'upm')]))
 bad<-d;bad$fexp[1]<-0;testthat::expect_error(validate_frame(bad));bad<-d;bad$sexo<-factor(as.character(bad$sexo));testthat::expect_error(validate_frame(bad))
})
testthat::test_that('all expected sample sizes and key OR checkpoints pass',{
 q<-rd('results/checkpoints/REPRODUCTION_QA.csv');testthat::expect_equal(nrow(q),28L);testthat::expect_true(all(q$status=='PASS'));testthat::expect_equal(q$actual[q$check=='PIVOT_N'],19750);testthat::expect_equal(q$actual[q$check=='SAV_VS_S2_DISCORDANT_N'],1201)
})
testthat::test_that('all frozen aggregate hashes match',{
 m<-rd('data/derived_public/PUBLIC_AGGREGATE_MANIFEST.csv');testthat::expect_identical(vapply(m$path,sha,''),setNames(m$sha256,m$path))
})
testthat::test_that('release text contains no absolute personal directory',{
 f<-c(list.files('R',recursive=TRUE,full.names=TRUE),list.files('scripts',full.names=TRUE),list.files('data/derived_public',full.names=TRUE),list.files('docs',recursive=TRUE,full.names=TRUE),'README.md','CITATION.cff','renv.lock');s<-unlist(lapply(f,readLines,warn=FALSE));pat<-paste0('/',c('Users/','home/'));testthat::expect_false(any(vapply(pat,function(p)any(grepl(p,s,fixed=TRUE)),TRUE)))
})
testthat::test_that('governed formulas and sensitivity coverage remain frozen',{
 r<-rd('config/MODEL_REGISTRY.csv');testthat::expect_equal(nrow(r),29L);testthat::expect_equal(as.integer(table(r$analysis_branch)[c('PRIMARY','OHRP7','INTERACTION')]),c(20L,8L,1L));testthat::expect_true(all(grepl('OWOBL_NUTRITION_S2',r$formula_S2,fixed=TRUE)));testthat::expect_true(all(r$policy=='fail/FALSE'))
})

