
args<-commandArgs(trailingOnly=TRUE);mode<-if('--full'%in%args)'full'else'public'
if(!all(args%in%c('--full','--public')))stop('Usage: Rscript run_all.R [--public|--full]')
source('scripts/00_check_environment.R')
for(f in sort(list.files('scripts',pattern='^[0-9].*\\.R$',full.names=TRUE))){if(!grepl('00_check',f,fixed=TRUE))source(f)}
source('tests/testthat.R')

