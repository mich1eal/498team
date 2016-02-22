rm(list=ls())

library(klaR)
library(caret)

# setwd('C:/Users/Michael/workspaces/CS498/HW3/problem3')


# Expects training data in working director with header removed.
dataRaw <- read.table('training.txt')

# Just to speed things up a bit
# dataRaw <- dataRaw[1:5000, ]

# For now, take 10% of the data for evaluation
part <- createDataPartition(y=dataRaw[,1], p=.9, list=FALSE)

trainY <- dataRaw[part, 1]
trainX <- dataRaw[part, -1]
evalY <- dataRaw[-part, 1]
evalX <- dataRaw[-part, -1]

trainX <- scale(trainX)
evalX <- scale(evalX)


model <- train(trainX, trainY, 'rf', trControl=trainControl(method='cv', number = 10))



results <- round(predict(model, evalX), digits=0)

score <- sum(results2 == evalY) / length(evalY)

sprintf("Classfier scored: %g", score)