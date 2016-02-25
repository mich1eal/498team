rm(list=ls())

library('lattice')

setwd('C:/Users/Michael/workspaces/CS498/HW4/Problem3_4/')
rawData <- read.csv('data/iris.data.txt', header=FALSE)

postscript('irisscatterplot.eps')

speciesnames <- c('setosa', 'versicolor', 'virginica')
pchr <- c(1, 2, 3)
colr <- c('red', 'green', 'blue', 'yellow', 'orange')

ss <- expand.grid(species = 1:3)
parset <- with(ss, simpleTheme(pch=pchr[species], col=colr[species]))

plt <- splom(rawData[, c(1:4)], groups=rawData$V5,
      par.settings=parset,
      vernames=c('Sepal\nLength', 'Sepal\nWidth',
                 'Petal\nLength', 'Petal\nWidth'),
      key=list(text=list(speciesnames),
               points=list(pch=pchr), columns=3))
# dev.off()

