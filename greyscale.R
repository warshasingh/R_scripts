library(doMC)
library(foreach)
library(iterators)
library(doParallel)
print(multicore:::detectCores())
registerDoParallel(cores=8)

library(EBImage)

frames <- list.files(path="~/Dropbox/git/test_photos", pattern=".jpg")

GREYFN <- function(i) {
  
  imrgb <- readImage(i)
  im <- channel(imrgb, 'gray')
  fnam = paste("gray", i,  sep="")
  writeImage(im, fnam)
  
}

ptime <- system.time ({
  foreach (i=frames) %dopar% {
    GREYFN(i)
  }
})

ptime
