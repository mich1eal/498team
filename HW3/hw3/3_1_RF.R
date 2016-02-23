rm(list=ls())  #clear all variables in the workspace

# setwd('Z:/Akshay/courses/CS498/HW3')
setwd('C:/Users/Michael/workspaces/CS498/HW3/Michael/problem1')

library(klaR)
library(caret)

load('all_datasets.RData')

part <- createDataPartition(y=train_dataset[,1], p=.01, list=FALSE)

bigx<-train_dataset[part,-c(1)]
bigy<-as.factor(train_dataset[part ,1])

model<-train(bigx, bigy, 'rf', trControl=trainControl(method='cv', number = 10))

names(v1x) <- names(bigx)
names(v2x) <- names(bigx)
names(v3x) <- names(bigx)
names(totalTrain) <- names(bigx)

tr_labels<-predict(model, totalTrain)
valid1_labels<-predict(model, v1x)
valid2_labels<-predict(model, v2x)
valid3_labels<-predict(model, v3x)

tr_correct<-tr_labels==as.factor(train_dataset[ ,1])
valid1_correct<-valid1_labels==valid1y[,2]
valid2_correct<-valid2_labels==valid2y[,2]
valid3_correct<-valid3_labels==valid3y[,2]

tr_score<-sum(tr_correct)/length(tr_correct)
valid1_score<-sum(valid1_correct)/(sum(valid1_correct)+sum(!valid1_correct))
valid2_score<-sum(valid2_correct)/(sum(valid2_correct)+sum(!valid2_correct))
valid3_score<-sum(valid3_correct)/(sum(valid3_correct)+sum(!valid3_correct))