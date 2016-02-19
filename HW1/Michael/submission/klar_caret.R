rm(list=ls())

library(klaR)
library(caret)

setwd('C:/Users/Michael/Dropbox/CS498/HW1')
wdat <- read.csv('data.txt', header=FALSE)

testCt <- 10
tescore <- array(dim=testCt)
bigx <- wdat[,-c(9)]
bigy <- as.factor(wdat[,9])

for (wi in 1:testCt) {
  wtd <- createDataPartition(y=bigy, p=.8, list=FALSE)
  trax <- bigx[wtd,]
  tray <- bigy[wtd]
  model <- train(trax, tray, 'nb', trControl=trainControl(method='cv', number=10))
  teclasses <- predict(model,newdata=bigx[-wtd,])
  confusionMatrix(data=teclasses, bigy[-wtd])
  tescore[wi] <- postResample(teclasses, bigy[-wtd])[1]
}

plot(1:testCt, tescore, 
     main='Results for 10 trials of NBC built with klaR and caret libraries',
     xlab='Exeriment #', 
     ylab='Test score (percent)'
)
avScore <- mean(tescore)

abline(a=avScore, b = 0, col='red')