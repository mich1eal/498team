rm(list=ls())
library(caret)

setwd('C:/Users/Michael/Dropbox/CS498/HW2')
dataRaw <- read.csv(file="./data/adult_combined.txt")

# Keep only continuous data
contIndex <- c(1, 3, 5, 11, 12, 13)
featureCount <- length(contIndex)
dataCont <- dataRaw[, contIndex]

# Scale it up
bigX <- scale(dataCont)

# Change > or < 50k to 1, -1
greater <- dataRaw[, 15] == ' >50K'
bigY <- ifelse(greater, 1, -1)

# Split data into 3 groups 80-10-10
index80 <- createDataPartition(y=bigY, p=.8, list=FALSE)
trainX <- bigX[index80, ]
trainY <- bigY[index80]
remainX <- bigX[-index80, ]
remainY <- bigY[-index80]
index10 <- createDataPartition(y=remainY, p=.5, list=FALSE)
valX <- remainX[index10, ]
valY <- remainY[index10]
testX <- remainX[-index10, ]
testY <- remainY[-index10]

# Variables for calculation 
lambda <- .001  #vary this
epochCount <- 50
stepCount <- 300
totalSteps <- 0
graphAt <- 30 # every 30 steps is a graphing datapoint
holdOut <- 50

a <- array(data=0, dim=featureCount)
b <- 0

accuracies <- array(data=0, dim=epochCount*stepCount/graphAt)
accuracyInd <- 1

# Start calculation
for (epoch in 1:epochCount){
  sprintf("Starting epoch %g", epoch)
  
  # determine step length
  eta <- 1 / (10 * epoch + 50)
  
  # set aside data for progress checking
  progInd <- sample(nrow(trainX), holdOut)
  holdX <- trainX[progInd, ]
  holdY <- trainY[progInd]
  remainX <- trainX[-progInd, ]
  remainY <- trainY[-progInd]
  
  for (step in 1:stepCount){
    # get a random data entry
    randInd <- sample(nrow(remainX), 1)
    x <- remainX[randInd, ]
    y <- remainY[randInd]
    
    # Check if correct and make necessary adjustments
    if (y*(sum(a*x) + b) >= 1){
      deltaA <- lambda * a
      deltaB <- 0
    }
    else {
      deltaA <- lambda * a - y*x
      deltaB <- -y
    }
    
    # update a and b 
    a <- a - eta * deltaA
    b <- b - eta * deltaB
    
    #Plot progress 
    if (totalSteps %% graphAt == 0){
      # get score
      score <- 0
      for (i in 1:holdOut){
        if((sum(a*holdX[i]) + b) * holdY[i] > 0){
          score <- score + 1 / holdOut
        }
      }
      
      accuracies[accuracyInd] <- score
      accuracyInd <- accuracyInd + 1
      sprintf("Finishing step %g with an accuracy of %g.", totalSteps, score)
    }
    
    totalSteps <- totalSteps + 1
  }
}

# Calculate validation score. Could be used to choose best scheme but I'm only using one
valCorrect <- 0
for (i in 1:length(valY)) {
  if((sum(a*valX[i]) + b) * valY[i] > 0){
    valCorrect <- valCorrect + 1
  }
}
valScore <- valCorrect / length(valY)

# Calculate test score. Will be identical process to validation score because I am only using one scheme at a time
testCorrect <- 0
for (i in 1:length(testY)) {
  if((sum(a*testX[i]) + b) * testY[i] > 0){
    testCorrect <- testCorrect + 1
  }
}
testScore <- testCorrect / length(testY)

# Plot results
frame()
plot(1:length(accuracies) * graphAt, accuracies, 
     main=sprintf('Results for SVM with lambda = %g', lambda),
     xlab='Step Number', 
     ylab='Test score (percent)',
     ylim=c(0, 1)
)
lines(1:length(accuracies) * graphAt, accuracies, 
     main='Results for SVM',
     xlab='Step Number', 
     ylab='Test score (percent)'
)