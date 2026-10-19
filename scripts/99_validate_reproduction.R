
expected<-rd('results/checkpoints/EXPECTED_RESULTS.csv')
actual<-setNames(rep(NA_real_,nrow(expected)),expected$check) # overwritten below from independent source tables
tr<-rd('data/derived_public/SAV_VS_S2_TRANSITION_CHECKPOINTS.csv');fig<-rd('data/derived_public/FIGURE2_S2_DATA.csv');k<-rd('data/derived_public/FIGURE_S2_S2_FOREST_DATA.csv');g<-rd('data/derived_public/S9_S2_GLOBAL_TESTS_FROZEN_L.csv');it<-rd('data/derived_public/S9B_INTERACTION_FROZEN_L.csv');oc<-rd('data/derived_public/OHRP6_COMPONENTS.csv')
actual[c('F4_N','PIVOT_N','CHILD_N','ADOLESCENT_N','S2_EVALUABLE_N','SAV_VS_S2_DISCORDANT_N')]<-c(NA_real_,tr$total[tr$domain=='total'],tr$total[tr$domain=='children'],tr$total[tr$domain=='adolescents'],sum(fig$n_observed[fig$domain=='total']),tr$discordant[tr$domain=='total'])
# F4 is the documented source-frame checkpoint, not derived from released microdata.
actual['F4_N']<-rd('data/derived_public/FRAME_CHECKPOINTS.csv')$N[1]
for(dom in k$domain)for(v in c('OR','CI_low','CI_high','p'))actual[paste(dom,v,sep='__')]<-k[k$domain==dom,v]
actual['children_global_p']<-g$p[g$model_id=='T2_OWOBNEW_OHRP6_children_adjusted'&g$arm=='svyglm'&g$test=='nutrition_main']
actual['nutrition_by_sex_p']<-it$p[it$arm=='svyglm'&it$row_type=='GLOBAL_TEST'&it$test=='nutrition_by_sex'&it$exposure=='S2_L']
q<-expected;q$actual<-unname(actual[q$check]);q$error<-abs(q$actual-q$expected);q$status<-ifelse(is.finite(q$error)&q$error<=q$tolerance,'PASS','FAIL');write.csv(q,'results/checkpoints/REPRODUCTION_QA.csv',row.names=FALSE)
stopifnot(all(q$status=='PASS'));writeLines(capture.output(sessionInfo()),'results/checkpoints/sessionInfo_local.txt')
message('PUBLIC CHECKPOINTS PASS: source hashes, cohort counts, five OR/CI/p sets, global and interaction tests.')

