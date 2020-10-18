#install.packages("survival", "survminer")
library(survminer)
library(survival)

bio<-read.table("data/BioSurvData6.txt",header = T,sep = ",")
bio
attach(bio)

b<-bio[apply(bio, 1, function(x) all(is.finite(x))), ]
names(b)<-c("time","censor","IT")
attach(b)

# tranform ischemic time to hours
IT<-b$IT/60

c<-table(b$censor)
censor<-b$censor
attach(b)

#divide ischemic time to 3 stages
it4<-cut(IT,3)

s<-Surv(time, censor)

# Descriptives
barplot(table(it4),col="steelblue",main = "Ischemic Time")
boxplot(time~it4,col=c("steelblue3","steelblue2","steelblue4"),main="Years of survival vs Ischemic Time")
cor(time,IT)#arnitiki sisxetisi

model1 <- survfit( s~ 1, conf.type="none")
summary(model1)
plot(model1, xlab="Time", ylab="Survival Probability",ylim=c(0.2,1.2),col="violetred4",lw=4,xlim=c(0,12),main="Kaplan - Meier Estimate")


# KAPLAN - MEIER
ggsurvplot(fKM)

ggsurvplot(fKM, conf.int=TRUE, pval=TRUE, risk.table=TRUE, 
           legend.labs=c("(0.51,2.89]","(2.89,5.27]","(5.27,7.66]"), legend.title="IT",  
           palette=c("dodgerblue2", "orchid2","darkcyan"), 
           title="Survival probability depending ischemic time", 
           risk.table.height=.15)


sCox1 <- coxph(s ~ IT,data=b)
summary(sCox1)
sCox2 <- coxph(s ~ it4,data=b,method="breslow")
summary(sCox2)


#Survival if the ischemic time is 1 hour

fKM$surv[IT=1]

