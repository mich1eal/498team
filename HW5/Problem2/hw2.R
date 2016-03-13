# 3/1/2016
# Michael Miller and Akshay Shetty for CS 498

rm(list=ls())

library('jpeg')
library('abind')
library('matrixStats')

setwd('C:/Users/Michael/workspaces/CS498/HW5/Problem 2/')

# Import data and format it so its usable. Seems overly complicated but couldn't find better way
rawData <- readJPEG('berries.jpg')
dataSize <- dim(rawData)
x <- dataSize[1]
y <- dataSize[2]

r <- as.vector(rawData[, , 1])
g <- as.vector(rawData[, , 2])
b <- as.vector(rawData[, , 3])

data <- cbind(r, g, b)
N <- dim(data)[1] # length of data

# COMPTATION 
err <- 1000
tolerance <- .1
maxClust <- 10 # Number of cluster centers

# for now, random initialization
theta <- matrix(runif(3*k), nrow=k, ncol=3)
w <- matrix(nrow = )

# Initialize variables

pi_ij <- array(1, dim=c(N, maxClust)) #1d array (cluster) 
p <- array(1, dim=c(N, maxClust, 3)) #3d array (cluster, x, RGB)
pOld <- array(500, dim=c(N, maxClust, 3)) #3d array (cluster, x, RGB)

x <- data
logA <- array(1, dim=c(N,maxClust)) #2d array (x, cluster)
logA_max <- array(1, dim=c(N,maxClust)) #2d array (x, cluster)
const <- array(1, dim=c(N,maxClust)) #2d array (x, cluster)
w <- array(1, dim=c(N,maxClust)) #2d array (x, cluster)



while(err > tolerance)
{
  # Do E-step
  
  for(i in 1:N){
    # 1. Compute log(Aj) for all j
    for(j in 1:maxClust){ 
      logA[i,j] <- log(pi_ij[i, j]) + sum(x*log(p[ ,1, ]))
    }
    
    # 2. Get max of Log(Aj)
    logA_max[i, ] <- max(logA[i, ])
    
    # 3. Compute constant term
    const[i, ] <- logSumExp(logA[i, ] - logA_max[i, ])
    
    # 4. get logY (combined)
    # 5. get w(i,j)
    w[i, ] <- exp(logA[i, ] - logA_max[i, ] - const[i, ])
  }
  
  
  
  
  
  # Do M-step
  
  p <- sum(x * w) / (sum(x * w))
  
  pi_j <- sum(w) / N
  
  
 
  err <- mean(abs(pOld - p) / abs(pOld))
  pOld <- p 
}









# Output png. This seems really annoying but I couldn't find a better way to do it
rPlane <- matrix(data[,1], nrow=x, ncol=y)
gPlane <- matrix(data[,2], nrow=x, ncol=y)
bPlane <- matrix(data[,3], nrow=x, ncol=y)
outMat <- abind(rPlane, gPlane, bPlane, along=3)

writeJPEG(outMat, 'output.jpg', quality=1)