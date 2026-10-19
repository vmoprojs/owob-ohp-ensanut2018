
options(stringsAsFactors=FALSE,digits=17,contrasts=c('contr.treatment','contr.poly'))
sha <- function(p) digest::digest(file=p,algo='sha256',serialize=FALSE)
oh <- function(x) digest::digest(x,algo='sha256')
rd <- function(p) read.csv(p,check.names=FALSE,stringsAsFactors=FALSE)
assert <- function(x,id,msg=NULL) {if(!isTRUE(x))stop(paste(id,msg),call.=FALSE);invisible(TRUE)}
same_lengths <- function(...)stopifnot(length(unique(vapply(list(...),length,0L)))==1L)
with_policy<-function(policy,domain,expr){old<-options(survey.lonely.psu=policy,survey.adjust.domain.lonely=domain);on.exit(options(old));force(expr)}
domain_mask<-function(d,dom)switch(dom,total=d$IN_OWOB_PIVOT,children=d$IN_OWOB_PIVOT&d$OWOBNEW_DOMAIN=='children',adolescents=d$IN_OWOB_PIVOT&d$OWOBNEW_DOMAIN=='adolescents',adolescent_male=d$IN_OWOB_PIVOT&d$OWOBNEW_DOMAIN=='adolescents'&d$sexo=='Male',adolescent_female=d$IN_OWOB_PIVOT&d$OWOBNEW_DOMAIN=='adolescents'&d$sexo=='Female')
ORitems<-function(x){yes<-rowSums(x==1,na.rm=TRUE)>0;allno<-rowSums(x==2,na.rm=TRUE)==ncol(x);ifelse(yes,1,ifelse(allno,0,NA_real_))}
validate_frame<-function(d){
 stopifnot(is.data.frame(d),all(c('id_per','upm','estrato','fexp','IN_OWOB_PIVOT','OWOBL_NUTRITION_S2','OWOBNEW_DOMAIN','sexo','OWOBNEW_OHRP6','OWOBNEW_SES_MCA_v1')%in%names(d)))
 stopifnot(!anyDuplicated(d$id_per),!anyNA(d$id_per),nrow(d)==23621,sum(d$IN_OWOB_PIVOT)==19750,all(is.finite(d$fexp)&d$fexp>0),!anyNA(d$upm),!anyNA(d$estrato))
 stopifnot(identical(levels(d$OWOBL_NUTRITION_S2),c('Healthy','Underweight','Overweight','Obesity')),identical(levels(d$OWOBNEW_SES_MCA_v1),c('High','Medium','Low')),identical(levels(d$sexo),c('Female','Male')))
 stopifnot(sum(d$OWOBNEW_DOMAIN=='children',na.rm=TRUE)==11319,sum(d$OWOBNEW_DOMAIN=='adolescents',na.rm=TRUE)==8431)
 stopifnot(sum(!is.na(d$OWOBL_NUTRITION_S2))==19750,sum(d$OWOBL_NUTRITION_S2!=d$OWOBNEW_NUTRITION,na.rm=TRUE)==1201)
 invisible(TRUE)
}

