## Packages 
#GISTools - from chapter 2 
install.packages("sf", dependencies =TRUE)
install.packages("sp", dependencies =TRUE)

library(GISTools)
# embedded data from the GISTools packages 

data(newhaven)
ls()
class(breach)
class(blocks)
head(data.frame(blocks))
#other way to see the data @
head(blocks@data)

#plot the blocks data
plot(blocks)

par(mar = c(0,0,0,0))
plot(roads, col="red")
plot(blocks, add = T)

## Everything should move to sf format 

library(sf)
vignette(package = "sf")

## Convert objects to sf 

# load the georgia data
data(georgia)
# conversion to sf
georgia_sf = st_as_sf(georgia)
class(georgia_sf)

# Plotting with sf

# all attributes
plot(georgia_sf)
# selected attribute
plot(georgia_sf[, 6])
# selected attributes
plot(georgia_sf[,c(4,5)])

#convert back to sp 

g2 <- as(georgia_sf, "Spatial")
class(g2)

## Reading and writing spatial data 
library(rgdal)

#stop section 3.3.2
