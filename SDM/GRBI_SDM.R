################
# This script deals with presence only data
# Victor Cameron
# 30/07/21
# Modified August 2021
###############

# The code in this script is adapted from Guillaume Blanchet work for the 2019 biodiversity modeling summer school


# 1 - Load data -----------------------------------------------------------


# Rasterized GRBI occurences for south of Québec
GRBI_points <- readRDS("./data_clean/GRBI_rasterPoints_sQ.RDS")

# Explanatory variables
explana_dat <- readRDS("./SDM/explana_dat.RDS")

# Polygon of the region boundaries
spacePoly <- readRDS("./SDM/spacePoly.RDS")


# 2 - Explore data --------------------------------------------------------


names(explana_dat)
dev.new()

# Rasterize GRBI occurences
GRBI_r <- raster::rasterize(raster::coordinates(GRBI_points)[,1:2], explana_dat[["bio1"]], fun='count', background=0)

# bio1 : mean annual temperature
hist(raster::values(explana_dat[["bio1"]])) 
boxplot(raster::values(explana_dat[["bio1"]]) ~ raster::values(GRBI_r))

# bio12 : mean annual precipitations
hist(raster::values(explana_dat[["bio12"]])) 
boxplot(raster::values(explana_dat[["bio12"]]) ~ raster::values(GRBI_r))

# elevation
hist(raster::values(explana_dat[["elevation"]]))
hist(raster::values(explana_dat[["elevation"]])[raster::values(GRBI_r) == 1]) 
boxplot(raster::values(explana_dat[["elevation"]]) ~ raster::values(GRBI_r))

# type_couv
table(raster::values(explana_dat[["type_couv"]]))

t <- table(raster::values(explana_dat[["type_couv"]]), raster::values(GRBI_r))
t[,1] <- t[,1]/colSums(t)[1]
t[,2] <- t[,2]/colSums(t)[2]
barplot(t, legend = TRUE)

# cl_dens
table(raster::values(explana_dat[["cl_dens"]]))

t <- table(raster::values(explana_dat[["cl_dens"]]), raster::values(GRBI_r))
t[,1] <- t[,1]/colSums(t)[1]
t[,2] <- t[,2]/colSums(t)[2]
barplot(t, legend = TRUE)

# cl_haut
table(raster::values(explana_dat[["cl_haut"]]))

t <- table(raster::values(explana_dat[["cl_haut"]]), raster::values(GRBI_r))
t[,1] <- t[,1]/colSums(t)[1]
t[,2] <- t[,2]/colSums(t)[2]
barplot(t, legend = TRUE)


# 3 - Likelihood for different numbers of quadrature points ---------------


# Select the number of quadrature points with saturated model
set.seed(123)
n.quad = c(1000, 5000, 10000, 50000, 100000, 500000, 1000000) # Model does not converge with > 1000000 quadrature points

for(i in 1:3){
    loglik = rep(NA, length(n.quad))

    for(j in 1:length(n.quad)){
    res <- SDM.glm(spacePoly=spacePoly, 
                 GRBI_points=GRBI_points,
                 covariables = ".", 
                 pred = explana_dat,
                 nquad = n.quad[j],         
                 quadOverlay = TRUE)
    model <- res[["model"]]

    ## Compute log likelihood
    mu <- model$fitted
    y <- res[["y"]]
    weights <- res[["weights"]]
    loglik[j] <- sum(weights*(y*log(mu) - mu))
    }

    if(i==1){
        dev.new()
        plot(n.quad, loglik, log = "x", type = "o")
    }else{
        lines(n.quad, loglik, type = "o", col="red")
    }
}


# 4 - Model selection -----------------------------------------------------

##################
# Habitat requirements of GRBI accoring to COSEWIC
## Habitat specialist
## 1. High elevation coniferous forests (windy, dense, naturally perturbed, coniferous)
## 2. lowland coastal forests (rainy, windy, dense, naturally perturbed, coniferous)
## 3. indistrial forests of the north (dense, perturbed, coniferous)
## dense coniferous forests non-perturbed
## perturbed forest in regeneration
## Altitude is an important factor: 450m-1000m minimum
## RL coincides with Mixed fores - boreal forest ecotone
##################

##################
# Hypotheses
## 1. T, P, elevation, and forest cover are important : "bio1 + bio12 + elevation + type_couv + cl_dens + cl_haut"
## 2. T, P, elevation, and forest cover are important and forest cover interacts with elevation : "bio1 + bio12 + elevation * type_couv * cl_dens * cl_haut"
## 3. T, P, elevation, and forest cover are important and climate interacts with elevation : "bio1 * bio12 * elevation + type_couv + cl_dens + cl_haut"
## 4. T, P, elevation, and forest cover are important and elevation interacts with climate and forest cover variables interact : "bio1 * bio12 * elevation + type_couv * cl_dens * cl_haut"
##################

# Model fomula
cov <- list(c("bio1^2 + bio12 + elevation + type_couv + cl_dens + cl_haut"),
            c("bio1^2 + bio12 + elevation * type_couv * cl_dens * cl_haut"),
            c("bio1^2 * bio12 * elevation + type_couv + cl_dens + cl_haut"),
            c("bio1^2 * bio12 * elevation + type_couv * cl_dens * cl_haut"),
            c("bio1^2 * bio12 * elevation + type_couv * cl_dens + cl_haut"))

aic = rep(NA, length(cov))

for(i in 5:length(cov)){
  # Downweighted poisson regression (point process model)
  res <- SDM.glm(spacePoly=spacePoly, 
                  GRBI_points=GRBI_points,
                  covariables = cov, 
                  pred = explana_dat,
                  nquad = 1000000,         
                  quadOverlay = TRUE,
                  nquadWanted = FALSE)

  aic[i] <- res[["model"]]$aic
}

plot(1:length(cov), aic, type = "o")
(covariables <- cov[which.min(aic)])


# Summary
model <- res[["model"]]
summary(model)
# AUC and plot
SDM.AUC(model, newdata=explana_dat, GRBI_points=GRBI_points, RL_cutoff = 0.05, plot_prediction = TRUE)
# Plot predictions
SDM.plot(model, newdata = explana_dat, logPred = TRUE, GRBI_points, points = TRUE, main = "GLM prediction (log)")
# Estimated number of quadrature point needed
mod[["nquadWanted"]]


# 5 - Climate warming projection ------------------------------------------


# Saturated model
  # # Downweighted poisson regression (point process model)
  cov <- c("bio1 * bio12 * elevation + type_couv + cl_dens + cl_haut")
  res <- SDM.glm(spacePoly=spacePoly, 
                  GRBI_points=GRBI_points,
                  covariables = cov, 
                  pred = explana_dat,
                  nquad = 1000000,         
                  quadOverlay = TRUE,
                  nquadWanted = FALSE)
model <- res[["model"]]
summary(model)
# Plot predictions
SDM.plot(model, newdata = explana_dat, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction (log)")
# Predictions for Eastern Townships
SDM.plot(model, newdata = explana_dat, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction EasternTownships (log)", xlim=c(-73,-70), ylim=c(45,46))

#### + 2°C ####
explana_warm2 <- explana_dat
raster::values(explana_warm2[["bio1"]]) <- raster::values(explana_warm2[["bio1"]]) + 2
# Plot predictions
SDM.plot(model, newdata = explana_warm2, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction +2°C")
# Predictions for Eastern Townships
SDM.plot(model, newdata = explana_warm2, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction +2°C EasternTownships (log)", xlim=c(-73,-70), ylim=c(45,46))

#### + 4°C ####
explana_warm4 <- explana_dat
raster::values(explana_warm4[["bio1"]]) <- raster::values(explana_warm4[["bio1"]]) + 4
# Plot predictions
SDM.plot(model, newdata = explana_warm4, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction +4°C")
SDM.plot(model, newdata = explana_warm4, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction +4°C EasternTownships (log)", xlim=c(-73,-70), ylim=c(45,46))


# 6 - Functions -----------------------------------------------------------


#==========================
# Function to run non 
# spatial SDMs 
#==========================

SDM.glm <- function(spacePoly, GRBI_points, covariables = ".", pred, nquad = 10000, quadOverlay = TRUE, nquadWanted = FALSE){
  # quadOverlay if true, quadrature points are randomly placed, if false, those overlaying GRBI points are excluded
    
    # Find the area of the survey region
    areaRegion <- raster::area(spacePoly)/1000000

    # Define random samples
    set.seed(12)
    xSmpl <- runif(5000000, raster::xmin(spacePoly), raster::xmax(spacePoly))
    ySmpl <- runif(5000000, raster::ymin(spacePoly), raster::ymax(spacePoly))
    
    # Organise them into a SpatialPoints object
    xySmpl <- sp::SpatialPoints(cbind(xSmpl, ySmpl), proj4string = spacePoly@proj4string)
    ## Reject those where there are GRBI points
    if(!quadOverlay){
      xySmpl_raster <- raster::rasterize(raster::coordinates(xySmpl)[,1:2], pred[[1]], fun='count', background=0)
      xySmpl_raster[xySmpl_raster>=1] <- 1
      GRBI_raster <- raster::rasterize(raster::coordinates(GRBI_points)[,1:2], pred[[1]], fun='count', background=0)
      xySmpl_raster[GRBI_raster > 0] <- 0
      xySmpl <- sp::SpatialPoints(xySmpl_raster, proj4string = spacePoly@proj4string)
    }

    # Construct a SpatialPolygons object
    landPoly <- maptools::unionSpatialPolygons(spacePoly, ID = rep(1,length(spacePoly)))
    
    # Find which one is in landPoly
    quadIntersect <- raster::intersect(xySmpl, landPoly) 
    
    # Select nquad of the selected points
    quadSel <- raster::coordinates(quadIntersect)[1:nquad,]
    
    # Organise coordinates
    spQuadxy <- rbind(raster::coordinates(GRBI_points)[,1:2], quadSel)
    
    # Extract variables
    datSpQuad <- raster::extract(pred, raster::coordinates(spQuadxy), method = "simple")
    datSpQuad <- as.data.frame(datSpQuad)
    
    # Build response variable
    spQuad <- c(rep(1, length(GRBI_points)), rep(0, nquad))

    # Build weight
    Weight <- rep(1/nquad, length(spQuad)) 
    Weight[spQuad == 0] <- areaRegion / nquad

    # Point process model
    model <- glm(formula(paste("spQuad/Weight ~ ", covariables)),
                data = datSpQuad, 
                family = poisson(), 
                weights = Weight) 

    # Check if enough quadrature points were used
    # # Calculate the estimated intensity at the quadrature points
    if(nquadWanted){
        predQuad <- datSpQuad[-(1:length(GRBI_points)),]
        intensityQuad <- predict(model,
                                newdata = predQuad,
                                type = "response")
        sdIntensityQuad <- sd(intensityQuad, na.rm=TRUE)
        nquadWanted <- areaRegion^2 * sdIntensityQuad^2 / qnorm(0.975)
    }else{
        nquadWanted <- NULL
    }
    

    return(list("model" = model, y = spQuad/Weight, weights = Weight, nquadWanted = nquadWanted))
}


#==========================
# Function to plot non 
# spatial SDMs 
#==========================

SDM.plot <- function(model, newdata, logPred = TRUE, GRBI_points, points = TRUE, ...){


    dat <- as.data.frame(raster::values(newdata))
    if(length(names(newdata)) == 1) names(dat) <- "datSpQuad"
    intensityMap <- predict(model,
                            newdata = dat,
                            type = "response")
    
    # Build the raster objects
    prediction <- raster::raster(newdata) 
    raster::values(prediction) <- intensityMap

    # Draw the map
    colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)

    dev.new()
    if(!logPred){
      raster::plot(prediction, col = colo,  zlim = c(0, max(raster::values(prediction), na.rm = TRUE)), axes = FALSE, box = FALSE, ...)
    }else{
      prediction[prediction < 0.01] <- 0.01
      logpred <- log(prediction)
      logpred[prediction == -Inf] <- 0
      raster::plot(logpred, col = colo,  zlim = c(min(raster::values(logpred), na.rm = TRUE), max(raster::values(logpred), na.rm = TRUE)), axes = FALSE, box = FALSE, ...)
      print("Intensity predictions were log-transformed")
    }
    
    if(points) points(raster::coordinates(GRBI_points), pch = 3, cex = 0.05)

}


#==========================
# Function to compute GLM model AUC
#==========================

SDM.AUC <- function(model, newdata, GRBI_points, RL_cutoff, plot_prediction = FALSE, points = TRUE,...){
  
  # Projection of the model from new data
  dat <- as.data.frame(raster::values(newdata))
  if(length(names(newdata)) == 1) names(dat) <- "datSpQuad"
  pred <- predict(model, newdata = dat, type = "response")

  # GRBI presence raster
  GRBI_raster <- raster::rasterize(raster::coordinates(GRBI_points)[,1:2], newdata[[1]], fun='count', background=0)  

  # Projected distribution raster
  pred[pred >= RL_cutoff] <- 1
  pred[pred < RL_cutoff] <- 0
  r <- newdata
  raster::values(r) <- pred
  
  # Plot prediction
  if(plot_prediction){
    dev.new()
    raster::plot(r[[1]], axes = FALSE, box = FALSE, ...) 
    if(points) points(GRBI_points, pch=19, cex=0.02)
  }

  # Compute AUC 
  pROC::auc(raster::values(GRBI_raster), pred) # Observed vs predicted (GRBI = raster values)
}

