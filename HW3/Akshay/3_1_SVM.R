rm(list=ls())  #clear all variables in the workspace

setwd('Z:/Akshay/courses/CS498/HW3')

library(klaR)
library(caret)

load('all_datasets.RData')

bigx<-train_dataset[,-c(1)]
bigy<-train_dataset[,1]

rw<-c(0.005, 0.01, 0.1)

tr_score<-array(dim=length(rw))
valid1_score<-array(dim=length(rw))
valid2_score<-array(dim=length(rw))
valid3_score<-array(dim=length(rw))

for (wi in c(1, 2, 3))
{
  wstring<-paste("-c", sprintf('%f', rw[wi]), sep=" ")
  svm<-svmlight(bigx, bigy, pathsvm='Z:/Akshay/courses/CS498/HW3/', svm.options=wstring)
  
  tr_preds<-predict(svm, bigx)
  valid1_preds<-predict(svm, valid1x)
  valid2_preds<-predict(svm, valid2x)
  valid3_preds<-predict(svm, valid3x)
  
  tr_labels<-tr_preds$class
  valid1_labels<-valid1_preds$class
  valid2_labels<-valid2_preds$class
  valid3_labels<-valid3_preds$class
  
  tr_correct<-tr_labels==bigy
  valid1_correct<-valid1_labels==valid1y[,2]
  valid2_correct<-valid2_labels==valid2y[,2]
  valid3_correct<-valid3_labels==valid3y[,2]
  
  tr_score[wi]<-sum(tr_correct)/(sum(tr_correct)+sum(!tr_correct))
  valid1_score[wi]<-sum(valid1_correct)/(sum(valid1_correct)+sum(!valid1_correct))
  valid2_score[wi]<-sum(valid2_correct)/(sum(valid2_correct)+sum(!valid2_correct))
  valid3_score[wi]<-sum(valid3_correct)/(sum(valid3_correct)+sum(!valid3_correct))
}

