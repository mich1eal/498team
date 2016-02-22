rm(list=ls())

library(klaR)
library(caret)

# setwd('C:/Users/Michael/workspaces/CS498/HW3/problem3')


# Expects training data in working director with header removed.
dataRaw <- read.table('training.txt')

# Just to speed things up a bit
dataRaw <- dataRaw[1:1000, ]

# For now, take 10% of the data for evaluation
part <- createDataPartition(y=dataRaw[,1], p=.9, list=FALSE)

trainY <- dataRaw[part, 1]
trainX <- dataRaw[part, -1]
evalY <- dataRaw[-part, 1]
evalX <- dataRaw[-part, -1]

trainX <- scale(trainX)
evalX <- scale(evalX)

modes <- kmodes(trainX, 5)

clusters <- modes$cluster

trainX1 <- trainX[clusters == 1, ]
trainX2 <- trainX[clusters == 2, ]
trainX3 <- trainX[clusters == 3, ]
trainX3 <- trainX[clusters == 4, ]
trainX3 <- trainX[clusters == 5, ]


trainY1 <- trainY[clusters == 1, ]
trainY2 <- trainY[clusters == 2, ]
trainX3 <- trainX[clusters == 3, ]
trainX3 <- trainX[clusters == 4, ]
trainX3 <- trainX[clusters == 5, ]

svm1 <- svmlight(trainX1, trainY1)
svm2 <- svmlight(trainX2, trainY2)
svm3 <- svmlight(trainX3, trainY3)



svm <- svmlight(trainX, trainY, pathsvm='.')



results <- unlist(predict(svm, evalX)$class)

score <- sum(unlist(results) == evalY) / length(evalY)

sprintf("Classfier scored: %g", score)