rm(list=ls())

library(klaR)
library(caret)

setwd('C:/Users/Michael/Dropbox/CS498/HW1')
wdat <- read.csv('data.txt', header=FALSE)

testCt <- 10
tescore <- array(dim=testCt)
bigx <- wdat[,-c(9)]
bigy <- as.factor(wdat[,9])

for (wi in 1:testCt){
  wtd <- createDataPartition(y=bigy, p=.8, list=FALSE)
  svm <- svmlight(bigx[wtd,], bigy[wtd], pathsvm='.')
  labels <- predict(svm, bigx[-wtd,])
  foo <- labels$class
  tescore[wi] <- sum(foo==bigy[-wtd])/(sum(foo==bigy[-wtd])+sum(!(foo==bigy[-wtd])))
}

plot(1:testCt, tescore, 
     main='Results for 10 trials of NBC built with SVMlight',
     xlab='Exeriment #', 
     ylab='Test score (percent)'
)
avScore <- mean(tescore)

abline(a=avScore, b = 0, col='red')