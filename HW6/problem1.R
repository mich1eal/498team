# 4/4/2016
# Michael Miller and Akshay Shetty for CS 498

rm(list=ls())

library('glmnet')

setwd('C:/Users/Michael/workspaces/CS498/HW6/')




# Do a test-train split (e.g., 70% train, 30% test)
n = nrow(X)
split = 0.7
train = sample(1:n, round(n * split))
y = latitude
Xtrain = X[train, ]
Xtest = X[-train, ]
ytrain = y[train]
ytest = y[-train]

# Train regression models 
# Find best regularization constant for each model via cross-validation (default = 10 folds)
ols = lm(ytrain ~ as.matrix(Xtrain))
lasso = cv.glmnet(as.matrix(Xtrain), ytrain, alpha = 1)
ridge = cv.glmnet(as.matrix(Xtrain), ytrain, alpha = 0)
elasticnet = cv.glmnet(as.matrix(Xtrain), ytrain, alpha = 0.5)

# Test regression models after finding best regularization constant for each
betahatols = coef(ols)
yhatols = cbind(rep(1, n - length(train)), as.matrix(Xtest)) %*% betahatols
yhatlasso = predict(lasso, as.matrix(Xtest), s = bestlambdalasso)
yhatridge = predict(ridge, as.matrix(Xtest), s = bestlambdaridge)
yhatelastic = predict(elasticnet, as.matrix(Xtest), s = bestlambdanet)

# Compare MSE on test data
sum((ytest - yhatols)^2) / nrow(Xtest)
sum((ytest - yhatlasso)^2) / nrow(Xtest)
sum((ytest - yhatridge)^2) / nrow(Xtest)
sum((ytest - yhatelastic)^2) / nrow(Xtest)