################
# This script deals with presence only data
# Victor Cameron
# 30/07/21
###############

# The code in this script is largely inspired and in large part taken from Guillaume Blanchet work for the 2019 biodiversity modeling summer school

# Load packages
library(sp) 
library(raster)
library(elevatr)

#### Load data ####
GRBI <- readxl::read_excel(here::here("data", "RAPPORT QO_SOS-POP SCF_GRBI.xlsx"), sheet = 2)
#GRBI <- readRDS(file.choose()) ; GRBI <- GRBI$Oporornis.agilis
climatePresent <- readRDS(here::here("data", "climate_Present.RDS"))
topo <- sf::read_sf(here::here("data", "topo_t.shp"))

# Get elevation
elevation <- get_elev_raster(topo, z = 5)

# Set LatLong limits
## Eastern townships
# xmin = -73
# xmax = -70
# ymin = 45
# ymax = 46
## South of Québec
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5
## Try just a patch
xmin = -72
xmax = -70
ymin = 47
ymax = 48.5


# Crop map extent to Eastern townships
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits
climatePresent <- raster::crop(climatePresent, e)
elevation <- raster::crop(elevation, e)
#elevation[elevation<0] <- 0

# Crop GRBI presence data
GRBI <- GRBI[GRBI$LONGITUDE>=xmin(climatePresent) & 
               GRBI$LONGITUDE<=xmax(climatePresent) & 
               GRBI$LATITUDE>=ymin(climatePresent) & 
               GRBI$LATITUDE<=ymax(climatePresent),]

# Get more precise elevation
#elevation_reduced <- get_elev_raster(elevation_reduced, z = 5)

# Sneak peek at the data
plot(climatePresent[[1]]) 
points(GRBI$LONGITUDE, GRBI$LATITUDE, pch = 19, cex = 0.1)

plot(elevation)
points(GRBI$LONGITUDE, GRBI$LATITUDE, pch = 19, cex = 0.1)


#### Survey region ####
library(maptools)

# Construct a SpatialPolygons object
landPoly <- rasterToPolygons(climatePresent[[1]]) 
landPoly <- unionSpatialPolygons(landPoly,
                                 ID = rep(1,length(landPoly)))

# Find the area of the survey region
areaRegion <- raster::area(landPoly)/1000000


#### Focus only on the occurences that fall into the survey regions ####
GRBI <- spRegion <- SpatialPoints(cbind(GRBI$LONGITUDE, GRBI$LATITUDE),
                                  proj4string = landPoly@proj4string)
spRegion <- intersect(GRBI, landPoly)

#### Define quadrature points ####

# Define random samples
set.seed(12)
xSmpl <- runif(200000, xmin(landPoly), xmax(landPoly))
ySmpl <- runif(200000, ymin(landPoly), ymax(landPoly))

# Organise them into a SpatialPoints object
xySmpl <- SpatialPoints(cbind(xSmpl, ySmpl),
                        proj4string = landPoly@proj4string)

# Find which one is in landPoly
quadIntersect <- intersect(xySmpl, landPoly) # Select 10000 of the selected points
nquad <- 150000
quadSel <- coordinates(quadIntersect)[1:nquad,]


#### Join climate and elevation data ####

elev <- climatePresent[[1]]

elevationPresent <- extract(elevation, coordinates(climatePresent),
                         method = "simple")

values(elev) <- elevationPresent

datPresent <- addLayer(climatePresent, elev)
names(datPresent[[1]]) <- 'bio1'
names(datPresent[[20]]) <- 'elevation'

#### Extracting data for the region of interest ####

# Organise coordinates
spQuadxy <- rbind(coordinates(spRegion), quadSel)

# Extract variables
datSpQuad <- extract(scale(datPresent), spQuadxy,
                         method = "simple")

# Organize data
datSpQuad <- as.data.frame(datSpQuad)


#### Using weighted GLMs ####

# Build response variable
spQuad <- c(rep(1, length(spRegion)), rep(0, nquad))

# Build weight
weight <- rep(1/nquad, length(spQuad)) 
weight[spQuad == 0] <- areaRegion / nquad

# Point process model
sel <- sample(length(spQuad), 1000) 

spModel <- glm(spQuad/weight ~.,
               data = datSpQuad, 
               family = poisson(), 
               weights = weight) 
summary(spModel)  

# Verify if there is enough quadrature points

# # Predictor data at quadrature points
predQuad <- datSpQuad[-(1:length(spRegion)),]

# # Calculate the estimated intensity at the quadrature points
intensityQuad <- predict(spModel,
                         newdata = predQuad,
                         type = "response")

# # Standard deviation of the estimated intensity at the quadrature points
sdIntensityQuad <- sd(intensityQuad, na.rm=TRUE)

nquadWanted <- areaRegion^2 * sdIntensityQuad^2 / qnorm(0.975) 
nquadWanted


#### Redefine quadrature points ####

# Define random samples
set.seed(12)
xSmpl <- runif(300000, xmin(landPoly), xmax(landPoly)) 
ySmpl <- runif(300000, ymin(landPoly), ymax(landPoly))

# Organise them into a SpatialPoints object
xySmpl <- SpatialPoints(cbind(xSmpl, ySmpl),
                        proj4string = landPoly@proj4string)

# Find which one is in landPoly
quadIntersect <- intersect(xySmpl, landPoly) # Select 200000 of the selected points
nquad <- 200000
quadSel <- coordinates(quadIntersect)[1:nquad,]


#### Extracting the climate data for the region of interest ####

# Organise coordinates
spQuadxy <- rbind(coordinates(spRegion), quadSel)

# Extract climate variables
datSpQuad <- extract(scale(datPresent), 
                         spQuadxy,
                         method = "simple")

# Organize climate data
datSpQuad <- as.data.frame(datSpQuad)


#### Recalculate the downweighted Poisson regression ####

# Build response variable
spQuad <- c(rep(1, length(spRegion)), rep(0, nquad))

# Build weight
weight <- rep(1/nquad, length(spQuad)) 
weight[spQuad == 0] <- areaRegion / nquad

# Point process model
sel <- sample(length(spQuad), 1000)

spModel <- glm(spQuad/weight ~., 
               data = datSpQuad,
               family = poisson(), 
               weights = weight)

summary(spModel)

#### Check if enough quadrature points were used ####

# Climate data at quadrature points
predQuad <- datSpQuad[-(1:length(spRegion)),]

# Calculate the estimated intensity at the quadrature points
intensityQuad <- predict(spModel,
                         newdata = predQuad,
                         type = "response")

#
intensityQuad[intensityQuad>0.1] <- 0

# Standard deviation of the estimated intensity at the quadrature points
sdIntensityQuad <- sd(intensityQuad)
SE <- areaRegion * sdIntensityQuad / sqrt(nquad) 
SE

#### Draw a map of the model ####

climateDat <- as.data.frame(scale(values(datPresent)))

# Calculate the estimated intensity for the survey region
intensityMap <- predict(spModel,
                        newdata = Dat,
                        type = "response")

# Build the raster objects
pred <- raster(climatePresent) 
values(pred) <- intensityMap

# Draw the map
plot(pred)

