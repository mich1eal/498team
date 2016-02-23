# Michael Miller and Akshay Shetty
# 2/18/2016
# CS 498 Machine Learning

rm(list=ls()) #clear workspace

library(RANN)

# setwd('Z:/Akshay/courses/CS498/HW3')
setwd('C:/Users/Michael/workspaces/CS498/HW3/Michael/')


attrRaw <- read.csv(file="attributes_cleaned.csv")
load('all_datasets.RData')

# Split names and attributes into separate matrices
names <- attrRaw[, 1]
attr <- attrRaw [, -(1:2)] #There's also an index in column 2

# Split data and true/false into separate matrices
# Change this to run on different evaluation sets

#match <- as.factor(train_dataset[part ,1])
#data <- train_dataset[part,-c(1)]
match <- valid1y[,2]
data <- valid1x

# concatenate vectors into single column
vect1 <- data[, 1:73]
vect2 <- data[, 74:146]
names(vect1) <- names(vect2) # R wants the column names to be the same when concatenating 
dataStacked <- rbind(vect1, vect2)
n = dim(dataStacked)[1] #get size

# do nearest neighbor search
nnOutput <- nn2(attr, query=dataStacked, k=1)

#Split output back into two vectors
nnVect <- unlist(nnOutput[1])
vect1 <- nnVect[1:(n/2)]
vect2 <- nnVect[(n/2 + 1):n]

#Get the corresponding names
names1 <- names[vect1]
names2 <- names[vect2]

#Check if the names are the same
result <- names1 == names2

# Calculate how many are correct based on original vector
testCorrect <- 0
for (i in 1:(length(match))) {
  if(result[i] == match[i]){
    testCorrect <- testCorrect + 1
  }
}

testScore <- testCorrect / length(match)

sprintf("Finished with an accuracy of %g.", testScore)