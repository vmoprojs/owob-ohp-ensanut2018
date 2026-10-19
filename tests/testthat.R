if(!exists('mode'))mode<-'public'

source('R/functions_core.R');source('R/functions_who2007.R')
testthat::test_dir('tests/testthat',reporter='summary',stop_on_failure=TRUE)

