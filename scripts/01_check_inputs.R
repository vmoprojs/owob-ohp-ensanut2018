
source('R/functions_core.R')
m<-rd('data/derived_public/PUBLIC_AGGREGATE_MANIFEST.csv')
stopifnot(all(file.exists(m$path)),all(vapply(m$path,sha,'')==m$sha256))
if(identical(mode,'full')){
 im<-rd('data/input_manifest.csv');p<-file.path('data/raw',im$expected_filename)
 if(!all(file.exists(p)))stop('FULL requires nonredistributed inputs listed in data/input_manifest.csv; see DATA_ACCESS.md')
 stopifnot(all(vapply(p,sha,'')==im$sha256))
}

