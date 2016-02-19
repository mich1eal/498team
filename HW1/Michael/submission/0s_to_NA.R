rm(list=ls())

library(klaR)
library(caret)

setwd('C:/Users/Michael/Dropbox/CS498/HW1')
wdat<-read.csv('data.txt', header=FALSE)

testCt <- 10
bigx <- wdat[,-c(9)]
bigy <- wdat[,9]
nbx <- bigx

for (i in c(3, 4, 6, 8)){
  vw <- bigx[, i] == 0
  nbx[vw, i] = NA
}

trscore<-array(dim=testCt)
tescore<-array(dim=testCt)
for (wi in 1:testCt){
  wtd <- createDataPartition(y=bigy, p=.8, list=FALSE)
  ntrbx <- nbx[wtd, ]
  ntrby <- bigy[wtd]
  trposflag <- ntrby>0
  ptregs <- ntrbx[trposflag, ]
  ntregs <- ntrbx[!trposflag,]
  ntebx <- nbx[-wtd, ]
  nteby <- bigy[-wtd]
  ptrmean <- sapply(ptregs, mean, na.rm=TRUE)
  ntrmean <- sapply(ntregs, mean, na.rm=TRUE)
  ptrsd <- sapply(ptregs, sd, na.rm=TRUE)
  ntrsd <- sapply(ntregs, sd, na.rm=TRUE)
  ptroffsets <- t(t(ntrbx)-ptrmean)
  ptrscales <- t(t(ptroffsets)/ptrsd)
  ptrlogs <- -(1/2)*rowSums(apply(ptrscales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ptrsd))
  ntroffsets <- t(t(ntrbx)-ntrmean)
  ntrscales <- t(t(ntroffsets)/ntrsd)
  ntrlogs <- -(1/2)*rowSums(apply(ntrscales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ntrsd))
  lvwtr <- ptrlogs>ntrlogs
  gotrighttr <- lvwtr==ntrby
  trscore[wi] <- sum(gotrighttr)/(sum(gotrighttr)+sum(!gotrighttr))
  pteoffsets <- t(t(ntebx)-ptrmean)
  ptescales <- t(t(pteoffsets)/ptrsd)
  ptelogs <- -(1/2)*rowSums(apply(ptescales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ptrsd))
  nteoffsets <- t(t(ntebx)-ntrmean)
  ntescales <- t(t(nteoffsets)/ntrsd)
  ntelogs <- -(1/2)*rowSums(apply(ntescales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ntrsd))
  lvwte <- ptelogs>ntelogs
  gotright <- lvwte == nteby
  tescore[wi] <- sum(gotright)/(sum(gotright)+sum(!gotright))
}

plot(1:testCt, tescore, 
     main='Results for 10 trials of NBC with 0s set to NA',
     xlab='Exeriment #', 
     ylab='Test score (percent)'
     )
avScore <- mean(tescore)

abline(a=avScore, b = 0, col='red')
