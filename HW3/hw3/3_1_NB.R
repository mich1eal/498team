rm(list=ls())  #clear all variables in the workspace

setwd('Z:/Akshay/courses/CS498/HW3')

library(klaR)
library(caret)

load('all_datasets.RData')

bigx<-train_dataset[,-c(1)]
bigy<-as.factor(train_dataset[,1])

model<-train(bigx, bigy, 'nb', trControl=trainControl(method='cv', number = 10))

tr_labels<-predict(model,newdata=bigx)
valid1_labels<-predict(model,newdata=valid1x)
valid2_labels<-predict(model,newdata=valid2x)
valid3_labels<-predict(model,newdata=valid3x)

tr_correct<-tr_labels==bigy
valid1_correct<-valid1_labels==valid1y[,2]
valid2_correct<-valid2_labels==valid2y[,2]
valid3_correct<-valid3_labels==valid3y[,2]

tr_score<-sum(tr_correct)/(sum(tr_correct)+sum(!tr_correct))
valid1_score<-sum(valid1_correct)/(sum(valid1_correct)+sum(!valid1_correct))
valid2_score<-sum(valid2_correct)/(sum(valid2_correct)+sum(!valid2_correct))
valid3_score<-sum(valid3_correct)/(sum(valid3_correct)+sum(!valid3_correct))