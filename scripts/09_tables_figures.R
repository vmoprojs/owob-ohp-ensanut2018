
# Re-render tables and scientific figures from frozen disclosure-reviewed aggregates.
for(f in c('TABLE1_S2_ALIGNED_PUBLICATION','TABLE2_S2_PUBLICATION','TABLE3_S2_PUBLICATION','STROBE_S16_S2_PUBLICATION')){
 x<-rd(paste0('data/derived_public/',f,'.csv'));write.csv(x,paste0('results/tables/',f,'.csv'),row.names=FALSE,na='')
 esc<-function(x){x<-gsub('&','&amp;',x,fixed=TRUE);x<-gsub('<','&lt;',x,fixed=TRUE);gsub('>','&gt;',x,fixed=TRUE)}
 h<-c('<!doctype html><meta charset="utf-8"><style>body{font-family:sans-serif}td,th{padding:6px;border:1px solid #ccc}table{border-collapse:collapse}</style>',paste0('<h2>',f,'</h2><p>Selected analytical sample; submission not authorized. Frozen numeric cells.</p><table>'),paste0('<tr><th>',paste(esc(names(x)),collapse='</th><th>'),'</th></tr>'),apply(x,1,function(r)paste0('<tr><td>',paste(esc(r),collapse='</td><td>'),'</td></tr>')),'</table>')
 writeLines(h,paste0('results/tables/',f,'.html'))
}
cols<-c('#23648A','#CC8844','#49A29C');doms<-c('total','children','adolescents');labels<-c('Total','Children','Adolescents')
png('results/figures/FIGURE1_OHRP6_COMPONENTS.png',width=1800,height=1100,res=160);par(mfrow=c(1,3),mar=c(8,4,4,1),oma=c(1,0,2,0))
for(j in seq_along(doms)){s<-components[components$domain==doms[j],];bp<-barplot(s$percent_weighted,names.arg=s$indicator,las=2,col=cols[j],ylim=c(0,40),ylab='Weighted percentage (95% CI)',main=labels[j],cex.names=.65);arrows(bp,s$CI_low_percent,bp,s$CI_high_percent,angle=90,code=3,length=.04)}
mtext('Reported oral health impacts: selected ENSANUT 2018 analytical sample',outer=TRUE,font=2);dev.off()
png('results/figures/FIGURE2_WHO2007_S2.png',width=1800,height=1000,res=160);par(mfrow=c(1,3),mar=c(6,4,4,1),oma=c(2,0,2,0))
for(j in seq_along(doms)){s<-nutrition[nutrition$domain==doms[j],];bp<-barplot(s$percent_weighted,names.arg=s$nutrition,las=2,col=cols[j],ylim=c(0,75),ylab='Weighted percentage (95% CI)',main=labels[j]);arrows(bp,s$CI_low,bp,s$CI_high,angle=90,code=3,length=.04)}
mtext('WHO 2007 S2 nutritional status: selected sample; oedema=n assumed',outer=TRUE,font=2);dev.off()
png('results/figures/FIGURE_S2_ADJUSTED_OBESITY.png',width=1700,height=1000,res=160);par(mar=c(5,11,4,2));s<-forest[match(c('total','children','adolescents','adolescent_male','adolescent_female'),forest$domain),];yy<-5:1
plot(s$OR,yy,log='x',xlim=c(.45,2.1),ylim=c(.5,5.5),yaxt='n',pch=19,col='#23648A',xlab='Adjusted odds ratio (95% CI), obesity vs healthy weight',ylab='',main='OHRP6: WHO 2007 S2, selected sample');axis(2,at=yy,labels=c('Total','Children','Adolescents','Adolescent males','Adolescent females'),las=1);segments(s$CI_low,yy,s$CI_high,yy,col='#23648A',lwd=2);abline(v=1,lty=2,col='gray50');dev.off()

