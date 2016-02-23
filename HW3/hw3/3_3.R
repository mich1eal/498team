rm(list=ls())  #clear all variables in the workspace

# setwd('Z:/Akshay/courses/CS498/HW3')
setwd('C:/Users/Michael/workspaces/CS498/HW3/Michael/problem1')

library(klaR)
library(caret)
library(R.matlab)

load('all_datasets.RData')

part <- createDataPartition(y=train_dataset[,1], p=.04, list=FALSE)

bigx<-train_dataset[part,-c(1)]

bigx <- scale(bigx)
totalTrain <- scale(train_dataset[, -1])
v1x <- scale(valid1x)
v2x <- scale(valid2x)
v3x <- scale(valid3x)

bigy<-as.factor(train_dataset[part ,1])


ptm <- proc.time()
model<-train(bigx, bigy, 'rf', trControl=trainControl(method='cv', number = 10))
totalTime <- proc.time() - ptm


dimnames(v1x)[2] <- dimnames(bigx)[2]
dimnames(v2x)[2] <- dimnames(bigx)[2]
dimnames(v3x)[2] <- dimnames(bigx)[2]
dimnames(totalTrain)[2] <- names(bigx)[2]
dimnames(eval_dataset)[2] <- dimnames(bigx)[2]


tr_labels<-predict(model, totalTrain)
valid1_labels<-predict(model, v1x)
valid2_labels<-predict(model, v2x)
valid3_labels<-predict(model, v3x)
eval_labels <- predict(model, eval_dataset)

tr_correct<-tr_labels==as.factor(train_dataset[ ,1])
valid1_correct<-valid1_labels==valid1y[,2]
valid2_correct<-valid2_labels==valid2y[,2]
valid3_correct<-valid3_labels==valid3y[,2]

tr_score<-sum(tr_correct)/length(tr_correct)
valid1_score<-sum(valid1_correct)/(sum(valid1_correct)+sum(!valid1_correct))
valid2_score<-sum(valid2_correct)/(sum(valid2_correct)+sum(!valid2_correct))
valid3_score<-sum(valid3_correct)/(sum(valid3_correct)+sum(!valid3_correct))

write.table(as.numeric(eval_labels) - 1, 'output.txt')

