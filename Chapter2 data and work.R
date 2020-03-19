## USING GIS - Chapter 2.

install.packages("GISTools", dependencies = T)
library(GISTools)
data("georgia")
## This loads three data sets
# The first elements of georgia.polys contains the coordinates for the 
#outline of Appling County

# select the first element 
appling <- georgia.polys[[1]]
# set the plot extent
plot(appling, asp=1, type='n', xlab="Easting", ylab="Northing")
# plot the selected features with hatching
polygon(appling, density=14, angle=135) 

plot(appling, asp=1, type='n', xlab="Easting", ylab="Northing")
polygon(appling, col=rgb(0,0.5,0.7))
# A fourth parameter can be added to indicate transparency range between 0 invisible to 1 opaque
polygon(appling, col=rgb(0,0.5,0.7,0.4))

# set the plot extent
plot(appling, asp=1, type='n', xlab="Easting", ylab="Northing")
# plot the points
points(x = runif(500,126,132)*10000, 
       y = runif(500,103,108)*10000, pch=16, col='red') 
# plot the polygon with a transparency factor
polygon(appling, col=rgb(0,0.5,0.7,0.4))

plot(appling, asp=1, type='n', xlab="Easting", ylab="Northing")
polygon(appling, col="#B5B334")
# add text, sepcifying its placement, colour and size 
## the numbers are the coordinates of the text placement.
text(1287000,1053000,"Appling County",cex=1.5) 
text(1287000,1049000,"Georgia",col='darkred')
## The function locator can be used to determine locations in the plot window.
#Enter locator() at the R prompts, and then left-click in the plot window at various locations
# when done, press finish button that is on top of the graph. The R console will show locations.

## Plotting rectangles 
plot(c(-1.5,1.5),c(-1.5,1.5),asp=1, type='n') 
# plot the green/blue rectangle
rect(-0.5,-0.5,0.5,0.5, border=NA, col=rgb(0,0.5,0.5,0.7)) 
# then the second one
rect(0,0,1,1, col=rgb(1,0.5,0.5,0.7))
## Tabular and raster data
# load some grid data
data(meuse.grid)
# define a SpatialPixelsDataFrame from the data
mat = SpatialPixelsDataFrame(points = meuse.grid[c("x", "y")], 
                             data = meuse.grid)
# set some plot parameters (1 row, 2 columns)
par(mfrow = c(1,2))
# set the plot margins
par(mar = c(0,0,0,0))
# plot the points using the default shading
image(mat, "dist")
# load the package
library(RColorBrewer)
# select and examine a colour palette with 7 classes
greenpal <- brewer.pal(7,'Greens') 
# and now use this to plot the data
image(mat, "dist", col=greenpal)
# reset par
par(mfrow = c(1,1))

## Work with ggplot 
library(ggplot2)

# To reproduce the Appling plots, the variable appling has to be converted from a matrix
# to a data frame whose elements need to labelled
appling<-data.frame(appling)
colnames(appling)<- c("X", "Y")

p1 <- qplot(X, Y, data = appling, geom = "polygon", asp = 1, 
            colour = I("black"),
            fill=I(rgb(0,0.5,0.7,0.4))) +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=20))
p1
# create a data.frame to hold the points 
df <- data.frame(x = runif(500,126,132)*10000, 
                 y = runif(500,103,108)*10000)
# now use ggplot to contruct the layers of the plot
p2 <- ggplot(appling, aes(x = X, y= Y)) +
  geom_polygon(fill = I(rgb(0,0.5,0.7,0.4))) +
  geom_point(data = df, aes(x, y),col=I('red')) +
  coord_fixed() +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=20))
p2
# finally combine these in a single plot 
# using the grid.arrange function
# NB you may have to install the gridExtra package
library(gridExtra)
grid.arrange(p1, p2, ncol = 2)

#data.frame
df<-data.frame(georgia)
#tibble
tb <- as_tibble(df)
#book asks for as.tibble but it has been deprecated. 

# Code creates indicator for rural and not rural. Set to values using the levels function.
# Note the +0 to convert the true and false values to 1s and 0s.

tb$rural <- as.factor((tb$PctRural > 50) +  0)
levels(tb$rural) <- list("Non-Rural" = 0, "Rural"=1)

#Create income category variable around the interquartile range of the MedInc variable
#(median county income). 
# rep - replicates values in x. 
tb$IncClass <- rep("Average", nrow(tb)) 

# creates a variables with only average values that are afterwards replaced. 
tb$IncClass[tb$MedInc >=  41204] = "Rich"
tb$IncClass[tb$MedInc <=  29773] = "Poor"

# Distributions can be checked 
table(tb$IncClass)

## Scatter plots to show two variables together.
# Scatter plot with PctBAch and PctEld

ggplot(tb,aes(PctBach, PctEld, colour=IncClass))+
  geom_point()

# to see clearer trends - add a trend line 
ggplot(data = tb, mapping = aes(x = PctBach, y = PctEld, colour= IncClass)) + 
  geom_point() +
  geom_smooth(method = "lm", col = "red", fill = "lightsalmon") + 
  theme_bw() +
  xlab("% of population with bachelor degree") +
  ylab("% of population that are elderly") 

# more elderly people that are poor and with less education

# Histograms to see distributions
ggplot(tb, aes(MedInc))+
  geom_histogram(, binwidth = 5000, colour= "red", fill = "grey")

ggplot(tb, aes(x=MedInc)) + 
  geom_histogram(aes(y=..density..),
                 binwidth=5000,colour="white") +
  geom_density(alpha=.4, fill="darksalmon") +
  # Ignore NA values for mean
  geom_vline(aes(xintercept=median(MedInc, na.rm=T)),
             color="orangered1", linetype="dashed", size=1)
## multiple plots can be created with the facet option 

ggplot(tb, aes(x=PctBach, fill=IncClass)) +
  geom_histogram(color="grey30",
                 binwidth = 1) +
  scale_fill_manual("Income Class", 
                    values = c("orange", "palegoldenrod","firebrick3")) +
  facet_grid(IncClass~.) +
  xlab("% Bachelor degrees") +
  ggtitle("Bachelors degree % in different income classes")

#Alterantive use boxplots 

ggplot(tb, aes(IncClass, PctBach, fill = factor(rural))) + 
  geom_boxplot() +
  scale_fill_manual(name = "Rural",
                    values = c("orange", "firebrick3"),
                    labels = c("Non-Rural"="Not Rural","Rural"="Rural")) +
  xlab("Income Class") +
  ylab("% Bachelors")









