## Does GLCM and produces a data matrix for classification
library(doMC)
library(foreach)
library(iterators)
library(doParallel)
print(multicore:::detectCores())
registerDoParallel(cores=8)

library(glcm)
library(raster)
#library(rgdal)

setwd("~/Dropbox/git/test_photos")

frames <- list.files(path="~/Dropbox/git/test_photos", pattern="gray")

GLCMFN <- function(i) {
  
  glcmmat <- matrix(rep(NA, 5*length(frames)), ncol=5)
  j<-1
  r <- raster(i)
  tr <- glcm(r, n_grey = 32, window = c(31, 31), shift=list(c(0,1), c(1,1), c(1,0), c(1,-1)), statistics = c("mean", "variance", "homogeneity", "contrast", "dissimilarity", "entropy", "second_moment", "correlation"), min_x=NULL, max_x=NULL, na_opt="any", na_val=NA, scale_factor=1, asinteger=FALSE)
  
    mn <- mean(getValuesBlock(tr$glcm_mean, row=200, nrows=300, col=200, ncol=400))
    var <- mean(getValuesBlock(tr$glcm_variance, row=200, nrows=300, col=200, ncol=400))
    homog <- mean(getValuesBlock(tr$glcm_homogeneity, row=200, nrows=300, col=200, ncol=400))
    entr <- mean(getValuesBlock(tr$glcm_entropy, row=200, nrows=300, col=200, ncol=400))
 
  dat <- cbind(i, mn, var, homog, entr)
  cat("Current j:",j,"\n")
  glcmmat[j,] <- dat
  j <- j+1
  
  write.table(dat, file="Pw31g32.txt", row.names = FALSE, col.names = FALSE,sep=",",append=T)
  cat("Finished R run for frame ",i," at ",system("date"),"\n")
}

ptime <- system.time ({
  foreach (i=frames) %dopar% {
      GLCMFN(i)
}
})

ptime
