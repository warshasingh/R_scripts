# ENHANCING IMAGE FROM AUV
# TEST SCRIPT

library(foreign)
library(EBImage)
setwd("~/Dropbox/git/test_photos")
a <- list.files()
a

#Reading in images.
img <- vector(mode="list", length=length(a))
for (i in a)
  img[[i]] <- readImage(i)

#img[[i]] <- readImage(paste("frame", i, ".jpg", sep=""))

#Image enhancement
d <- makeBrush(3, shape='box')
d2 <- d/sum(d)

for (i in a){
	bl <- (img[[i]]/gblur(img[[i]], sigma=70))/2
	f <- filter2(bl, d2)
	g <- (0.2+f)^2.5 #gamma correction to increase the grays. (0.25, 2.5)
#imgnew <- vector(mode="list", length=20)
	fnam = paste("en", i, sep="")
	writeImage(g, fnam)
}
#image divided by its blur, the result is divided by 2.

