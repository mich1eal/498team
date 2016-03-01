# 3/1/2016
# Michael Miller and Awkshay Shetty for CS 498

rm(list=ls())

library('lattice')
library('chemometrics')

setwd('C:/Users/Michael/workspaces/CS498/HW4/Problem3_4/')
rawData <- read.csv('data/iris.data.txt', header=FALSE)

postscript('part_a.eps')

speciesnames <- c('setosa', 'versicolor', 'virginica')
pchr <- c(1, 2, 3)
colr <- c('red', 'green', 'blue', 'yellow', 'orange')

ss <- expand.grid(species = 1:3)
parset <- with(ss, simpleTheme(pch=pchr[species], col=colr[species]))

print(splom(rawData[, c(1:4)], groups=rawData$V5,
      par.settings=parset,
      varnames=c('Sepal\nLength', 'Sepal\nWidth',
                 'Petal\nLength', 'Petal\nWidth'),
      key=list(text=list(speciesnames),
               points=list(pch=pchr), columns=3)))
dev.off()

# Part b
postscript('part_b.eps')

pComp <- princomp(rawData[, 1:4])
eigs <- pComp$loadings
centered <- sweep(rawData[, 1:4], MARGIN=2, pComp$center, FUN="-") #Center data
rotate <- centered * eigs
plot(rotate[,1], rotate[,2],
     col=colr[rawData$V5],
     xlab="Principle Component 1",
     ylab="Principle Component 2",
     main="Principle Components of Iris Dataset")
dev.off()

# Part c
postscript('part_c.eps')

y <- model.matrix(~rawData$V5 -1, data=rawData)
results <- pls2_nipals(rawData[,1:4], y, 2, scale=TRUE)
outVect <- results$T

plot(outVect[,1], outVect[,2],
     col=colr[rawData$V5],
     xlab="Discriminative Direction 1",
     ylab="Discriminative Direction 2",
     main="Discriminative Directions of Iris Dataset")
dev.off()
