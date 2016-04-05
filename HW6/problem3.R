# 4/4/2016
# Michael Miller and Akshay Shetty for CS 498

rm(list=ls())

library('glmnet')
library('xlsx')

setwd('C:/Users/Michael/workspaces/CS498/HW6/')


data <- read.csv('credit_card.csv', sep=",",header=TRUE)[-1,] # it has a double header so discard first row
data <- matrix(unlist(data), ncol=25)
class(data) <- 'numeric'

X <- data[, -25]
y <- data[, 25]

# Do a test-train split (e.g., 70% train, 30% test)
n = dim(data)[1]
split = 0.7
train = sample(1:n, round(n * split))



Xtrain = as.matrix(X[train, ])
Xtest = as.matrix(X[-train, ])
ytrain = as.matrix(y[train])
ytest = as.matrix(y[-train])

# Train regression models 
# Find best regularization constant for each model via cross-validation (default = 10 folds)
lasso = cv.glmnet(Xtrain, ytrain, alpha = 1, family='binomial', type.measure='class')
ridge = cv.glmnet(Xtrain, ytrain, alpha = 0, family='binomial', type.measure='class')
elast = cv.glmnet(Xtrain, ytrain, alpha =0.5, family='binomial', type.measure='class')


# Test regression models after finding best regularization constant for each
yLasso = predict(lasso, Xtest, s = 'lambda.min', type='class')
yRidge = predict(ridge, Xtest, s = 'lambda.min', type='class')
yElast = predict(elast, Xtest, s = 'lambda.min', type='class')


# Calculate percent correct 
sum(ytest == yhatols) / nrow(Xtest)
sum(ytest == yLasso) / nrow(Xtest)
sum(ytest == yRidge) / nrow(Xtest)
sum(ytest == yElast) / nrow(Xtest)