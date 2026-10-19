
needed<-c('digest','yaml','jsonlite','survey','haven','ade4','MASS','testthat')
missing<-needed[!vapply(needed,requireNamespace,TRUE,quietly=TRUE)]
if(length(missing))stop('Run renv::restore(); missing packages: ',paste(missing,collapse=', '))
options(survey.lonely.psu='fail',survey.adjust.domain.lonely=FALSE,contrasts=c('contr.treatment','contr.poly'))
message('Environment available. Primary survey policy: fail/FALSE. No stochastic model stage.')

config<-yaml::read_yaml('config/config.example.yml');stopifnot(config$mode=='public',isFALSE(config$submission_authorized))
