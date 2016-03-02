# 3/1/2016
# Michael Miller and Akshay Shetty for CS 498

rm(list=ls())

library('lattice')
library('chemometrics')
library('scatterplot3d')

setwd('C:/Users/Michael/workspaces/CS498/HW4/Problem3_7/')
rawData <- read.csv('data/wdbc.data.txt', header=FALSE)
cleanData <- cbind(rawData[,3:32], rawData[,2]) #get rid of ID's, move class to last column

# Split data
#split <- sample(nrow(cleanData), 100, replace=FALSE)
#val <- cleanData[split, ]
#remain <- cleanData[-split, ]

#split <- sample(nrow(remain), 100, replace=FALSE)
#test <- remain[split, ]
#train <- remain[-split, ]
# aparantly that wasn't actually required... 


colr <- c('red', 'green')

pca <- prcomp(cleanData[, 1:30])

rotate <- scale(cleanData[1:30], center=TRUE, scale=FALSE) %*% pca$rotation

postscript('part_a.eps')

scatterplot3d(rotate[,1], rotate[,2], rotate[,3], 
              color=colr[cleanData[,31]],
              xlab="Principle Component 1",
              ylab="Principle Component 2",
              zlab="Principle Component 3",
              main="Principle Components of Breast Cancer Diagnostics Dataset")
dev.off()

# Part b
pls <- pls1_nipals(cleanData[,1:30], (cleanData[, 31] == 'M'), 3, scale=TRUE)

outVect <- pls$T

postscript('part_b.eps')

scatterplot3d(outVect[,1], outVect[,2],outVect[,3],
     color=colr[cleanData[,31]],
     xlab="Discriminative Direction 1",
     ylab="Discriminative Direction 2",
     zlab="Discriminative Direction 3",
     main="Discriminative Directions of Breast Cancer Diagnostics Dataset")
dev.off()

