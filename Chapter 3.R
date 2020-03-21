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

#st_read and st_write to read files 

## using package tmap
install.packages(c("OpenStreetMap"),dependencies = TRUE) 
library(ggplot2)
library(ggmosaic)
library(OpenStreetMap)
library(RgoogleMaps)
library(grid)
library(rgdal)
library(sp)
library(tidyverse)
library(reshape2)
library(GISTools)
library(rgeos)
library(sf)
library(tmap)
data(georgia)

qtm(georgia, fill="red", style="natural")
#fill can be used to select a variable to be mapped. 

qtm(georgia_sf, fill="MedInc", text="Name", text.size=0.5, 
    format="World_wide", style="classic", 
    text.root=5, fill.title="Median Income")

## works like ggplot by layers 

# do a merge
g <- st_union(georgia_sf)
# for sp
# g <- gUnaryUnion(georgia, id = NULL)

# plot the spatial layers
tm_shape(georgia_sf) +
  tm_fill("tomato")

tm_shape(georgia_sf) +
  tm_fill("tomato") +
  tm_borders(lty = "dashed", col = "gold")

tm_shape(georgia_sf) +
  tm_fill("tomato") +
  tm_borders(lty = "dashed", col = "gold") +
  tm_style("natural", bg.color = "grey90")

tm_shape(georgia_sf) +
  tm_fill("tomato") +
  tm_borders(lty = "dashed", col = "gold") +
  tm_style("natural", bg.color = "grey90") +
  # now add the outline
  tm_shape(g) +
  tm_borders(lwd = 2) +
  tm_layout(title = "The State of Georgia", 
            title.size = 1, title.position = c(0.55, "top"))
# plotting more thann two maps 

# 1st plot of georgia
t1 <- tm_shape(georgia_sf) +
  tm_fill("coral") +
  tm_borders() +
  tm_layout(bg.color = "grey85") 
# 2nd plot of georgia2
t2 <- tm_shape(georgia2) +
  tm_fill("orange") +
  tm_borders() +
  # the asp paramter controls aspect
  # this is makes the 2nd plot align
  tm_layout(asp = 0.86,bg.color = "grey95")

# open a new plot page
grid.newpage()
# set up the layout
pushViewport(viewport(layout=grid.layout(1,2)))
# plot using the print command
print(t1, vp=viewport(layout.pos.col = 1, height = 5))
print(t2, vp=viewport(layout.pos.col = 2, height = 5))

# see tha names of the counties 
data.frame(georgia_sf)[,13]

# display names on the map 

tm_shape(georgia_sf) +
  tm_fill("white") +
  tm_borders() +
  tm_text("Name", size = 0.3) +
  tm_layout(frame = FALSE)

# Names can be subset 

# the county indices below were extracted from the data.frame
index <- c(81, 82, 83, 150, 62, 53, 21, 16, 124, 121, 17)
georgia_sf.sub <- georgia_sf[index,]

#plotting the subset 
tm_shape(georgia_sf.sub) +
  tm_fill("gold1") +
  tm_borders("grey") +
  tm_text("Name", size = 1) +
  # add the outline
  tm_shape(g) +
  tm_borders(lwd = 2) +
  # specify some layout parameters
  tm_layout(frame = FALSE, title = "A subset of Georgia", 
            title.size = 1.5, title.position = c(0., "bottom"))

# Bringing all together 

# the 1st layer
tm_shape(georgia_sf) +
  tm_fill("white") +
  tm_borders("grey", lwd = 0.5) +
  # the 2nd layer
  tm_shape(g) +
  tm_borders(lwd = 2) +
  # the 3rd layer
  tm_shape(georgia_sf.sub) +
  tm_fill("lightblue") +
  tm_borders() +
  # specify some layout parameters
  tm_layout(frame = T, title = "Georgia with a subset of counties", 
            title.size = 1, title.position = c(0.02, "bottom"))

## Adding context  - Using OpenStreetMap  which does not work because rJava is not working.
georgia.sub <- georgia[index,]
ul <- as.vector(cbind(bbox(georgia.sub)[2,2], 
                      bbox(georgia.sub)[1,1]))
lr <- as.vector(cbind(bbox(georgia.sub)[2,1], 
                      bbox(georgia.sub)[1,2]))
# download the map tile
MyMap <- openmap(ul,lr)
# now plot the layer and the backdrop
par(mar = c(0,0,0,0))
plot(MyMap, removeMargin=FALSE)
plot(spTransform(georgia.sub, osm()), add = TRUE, lwd = 2)