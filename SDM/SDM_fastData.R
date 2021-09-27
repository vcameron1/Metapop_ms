#############################################################
## SDMs using a subset of the data
## Victor Cameron
## August 2021
#############################################################

#==========================
# Dependencies
#==========================

# Load mapSpecies package locally
devtools::load_all("./mapSpecies/")
library(mapSpecies)


#==========================
# Load fast data
#==========================

load("./SDM/fast_data.RData")
explana$X <- raster::stack("./SDM/explana$X_fast_data.grd") # Solves issues with writing raster


# Spatial model -----------------------------------------------------------


# Spatial
model <- ppSpace(y ~ 0, sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
summary(model)
mapSpecies.plot(model, explana_dat, spacePoly, GRBI_points)


# elevation model ---------------------------------------------------------


# Spatial
modelPPelevation <- ppSpace(y ~ elevation, sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
summary(modelPPelevation)
plot(explana$X$elevation) 
points(GRBI_points, pch=19, cex=0.2)

# Non spatial
GLMelev <- SDM.glm(spacePoly=spacePoly, 
                   GRBI_points=GRBI_points, 
                   pred = explana$X$elevation,
                   nquad = 10000,
                   quadOverlay = FALSE)
summary(GLMelev) 
anova(GLMelev, test = 'Chisq')
SDM.plot(GLMelev, newdata = explana$X$elevation, GRBI_points, main = "GLM elevation prediction")
SDM.AUC(GLMelev, newdata=explana$X$elevation, GRBI_points=GRBI_points, RL_cutoff = 0.5, plot_prediction = TRUE) 
# 0.7933 (quadOverlay=T; nquad = 10000) AIC: 10500
# 0.9011 (quadOverlay=F; nquad = 10000) AIC: 6207.4
# 0.7933 (quadOverlay=T; nquad = 15000)
# 0.9018 (quadOverlay=F; nquad = 15000)
# 0.7791 (quadOverlay=T; nquad = 5000)
# 0.9034 (quadOverlay=F; nquad = 5000) AIC: 5917.8



# bio1 model --------------------------------------------------------------


# Spatial
modelPPbio1 <- ppSpace(y ~ bio1, sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
summary(modelPPbio1) # n-signif
plot(explana$X$bio1) 
points(GRBI_points, pch=19, cex=0.2)

# Non spatial
GLMbio1 <- SDM.glm(spacePoly=spacePoly, 
                   GRBI_points=GRBI_points, 
                   pred = explana$X$bio1,
                   nquad = 10000)
summary(GLMbio1) # undrdispersion
SDM.plot(GLMbio1, newdata = explana$X$bio1, GRBI_points, main = "GLM bio1 prediction")
anova(GLMbio1, test = 'Chisq')
anova(GLMelev, GLMbio1, test = 'Chisq')
SDM.AUC(GLMbio1, newdata=explana$X$bio1, GRBI_points=GRBI_points, RL_cutoff = 0.5, plot_prediction = TRUE) 

GLMbio1_05 <- SDM.glm(spacePoly=spacePoly, 
                   GRBI_points=GRBI_points, 
                   pred = explana$X$bio1,
                   nquad = 5000)
summary(GLMbio1_05)
anova(GLMbio1, GLMbio1_05)


# Sud Qc model ------------------------------------------------------------

# Load data
GRBI_points <- readRDS("./data_clean/GRBI_rasterPoints_sQ.RDS")
explana_dat <- readRDS("./SDM/explana_dat.RDS")
spacePoly <- readRDS("./SDM/spacePoly.RDS")

formu <- formula(spQuad/Weight ~ bio1 + bio12 + elevation * type_couv + elevation * cl_dens + elevation * cl_haut)
model <- SDM.glm(spacePoly=spacePoly, 
                   GRBI_points=GRBI_points,
                   formu = formu, 
                   pred = explana_dat,
                   nquad = 10000,        # AUC: 0.86 @ 5-15000; 0.87 @ 15000; 
                   quadOverlay = TRUE)
summary(model)
raster::plot(explana$X$elevation); points(GRBI_points)
SDM.AUC(model, newdata=explana_dat, GRBI_points=GRBI_points, RL_cutoff = 0.05, plot_prediction = TRUE)


# Predictors and model selection ------------------------------------------


#==========================
# Predictors and model selection
#==========================

cov <- list(full = formula(spQuad/Weight ~ .),
            elev = formula("spQuad/Weight ~ elevation"),
            bio1 = formula("spQuad/Weight ~ bio1"),
            base = formula(paste("spQuad/Weight ~", paste(c("bio1", "bio12", "elevation", "type_couv", "cl_dens", "cl_haut"), collapse = "+"))),
            forest = formula(paste("spQuad/Weight ~", paste(c("bio1", "bio12", "elevation", paste(c("type_couv", "cl_dens", "cl_haut"), collapse = "*")), collapse = "+"))),
            int = formula(paste("spQuad/Weight ~", paste(names(explana$X), collapse = "+"), " + bio1:elevation+type_couv:elevation:cl_dens")),
            try1 = formula(paste("spQuad/Weight ~", paste(c("bio1", "bio2", "bio3", "bio12", "bio15", "elevation*type_couv*cl_dens*cl_haut"), collapse = "+"))))


res <- data.frame(matrix(ncol=5, nrow=length(cov)))
names(res) <- c("predictors", "nquad", "overlay", "AIC", "AUC")
models <- list()
coefs <- list()
i=1

for(formu in cov){
  model <- SDM.glm(spacePoly=spacePoly, 
                   GRBI_points=GRBI_points,
                   formu = formu, 
                   pred = explana$X,
                   nquad = 10000,
                   quadOverlay = TRUE)

  #res$predictors[i] <- formu
  res$nquad[i] <- 10000
  res$overlay[i] <- TRUE
  res$AIC[i] <- summary(model)$aic
  res$AUC[i] <- SDM.AUC(model, newdata=explana$X, GRBI_points=GRBI_points, RL_cutoff = 0.05, plot_prediction = TRUE) 
  assign(paste0("model", i), model)
  assign(paste0("coefs", i), summary(model)$coefficients)
  
  i = i + 1
}
res

#==========================
# Function to run non 
# spatial SDMs 
#==========================

SDM.glm <- function(spacePoly, GRBI_points, formu = formula(spQuad/Weight ~ .), pred, nquad = 10000, quadOverlay = TRUE){
  # quadOverlay if true, quadrature points are randomly placed, if false, those overlaying GRBI points are excluded
    
    # Find the area of the survey region
    areaRegion <- raster::area(spacePoly)/1000000

    # Define random samples
    set.seed(12)
    xSmpl <- runif(200000, raster::xmin(spacePoly), raster::xmax(spacePoly))
    ySmpl <- runif(200000, raster::ymin(spacePoly), raster::ymax(spacePoly))
    
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
    model <- glm(formu,
                data = datSpQuad, 
                family = poisson(), 
                weights = Weight) 
    
    # Standard deviation of the estimated intensity at the quadrature points
    #sdIntensityQuad <- sd(intensityQuad)
    #SE <- areaRegion * sdIntensityQuad / sqrt(nquad)

    #cat("The standard error of the estimated intensity at the quadrature points is of", SE) 

    return(model)
}

#==========================
# Function to plot non 
# spatial SDMs 
#==========================

SDM.plot <- function(spModel, newdata, GRBI_points, ...){


    dat <- as.data.frame(raster::values(newdata))
    names(dat) <- "datSpQuad"
    intensityMap <- predict(spModel,
                            newdata = dat,
                            type = "response")
    
    # Build the raster objects
    prediction <- raster::raster(newdata) 
    raster::values(prediction) <- intensityMap

    # Draw the map
    colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)

    if(max(raster::values(prediction), na.rm = TRUE) < 100){
      raster::plot(prediction, col = colo,  zlim = c(0, max(raster::values(prediction), na.rm = TRUE)), axes = FALSE, box = FALSE, ...)
    }else{
      logpred <- log(prediction)
      logpred[prediction==-Inf] <- 0
      raster::plot(logpred, col = colo,  zlim = c(min(raster::values(logpred), na.rm = TRUE), max(raster::values(logpred), na.rm = TRUE)), axes = FALSE, box = FALSE, ...)
      print("Intensity predictions were log-transformed")
    }
    
    points(raster::coordinates(GRBI_points), pch = 19, cex = 0.05)

}

#==========================
# Function to plot SDMs 
#==========================

mapSpecies.plot <- function(model, explana_dat, spacePoly, GRBI_points){
  mapMean <- mapSpace(model,
                    dims = dim(explana_dat)[1:2],
                    type = "mean",
                    sPoly = spacePoly)
  # Standard deviation
  mapSd <- mapSpace(model,
                      dims = dim(explana_dat)[1:2],
                      type = "sd",
                      sPoly = spacePoly)
  # Lower boundary of the 95% confidence interval
  map.025 <- mapSpace(model,
                      dims = dim(explana_dat)[1:2],
                      type = "0.025quant",
                      sPoly = spacePoly)
  # Upper boundary of the 95% confidence interval
  map.975 <- mapSpace(model,
                      dims = dim(explana_dat)[1:2],
                      type = "0.975quant",
                      sPoly = spacePoly)
  #--------------------------------------
  # Cut raster with polygon of the region
  #--------------------------------------
  mapMaskMean <- mask(mapMean, spacePoly)
  mapMaskSd <- mask(mapSd, spacePoly)
  mapMask.025 <- mask(map.025, spacePoly)
  mapMask.975 <- mask(map.975, spacePoly)

  #--------------------------------------
  # Rescale predictions
  #--------------------------------------
  mapMaskMean <- mapMaskMean/max(values(mapMask.975), na.rm = TRUE)
  mapMaskSd <- mapMaskSd/max(values(mapMask.975), na.rm = TRUE)
  mapMask.025 <- mapMask.025/max(values(mapMask.975), na.rm = TRUE)
  mapMask.975 <- mapMask.975/max(values(mapMask.975), na.rm = TRUE)

  colo <- colorRampPalette(c("grey90", "steelblue4", 
                           "steelblue2", "steelblue1", 
                           "gold", "red1", "red4"))(200)

  par(mfrow = c(2,2), mar = c(1,1,5,8))
  plot(mapMaskMean, col = colo, zlim = c(0, 1),
      axes = FALSE, box = FALSE, main = "Mean")
  points(coordinates(GRBI_points), pch = 19, cex = 0.2)
  plot(mapMaskSd, col = colo,  zlim = c(0, 1),
      axes = FALSE, box = FALSE, main = "Sd")
  points(coordinates(GRBI_points), pch = 19, cex = 0.2)
  plot(mapMask.025, col = colo,  zlim = c(0, 1),
      axes = FALSE, box = FALSE, main = "2.5%")
  points(coordinates(GRBI_points), pch = 19, cex = 0.2)
  plot(mapMask.975, col = colo,  zlim = c(0, 1),
      axes = FALSE, box = FALSE, main = "97.5")
  points(coordinates(GRBI_points), pch = 19, cex = 0.2)
}


#==========================
# Function to compute GLM model AUC
#==========================

SDM.AUC <- function(model, newdata, GRBI_points, RL_cutoff, plot_prediction=FALSE){
  
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
    raster::plot(r[[1]]) 
    points(GRBI_points, pch=19, cex=0.05)
  }

  # Compute AUC 
  pROC::auc(raster::values(GRBI_raster), pred) # Observed vs predicted (GRBI = raster values)
}


#==========================
# Generate fast data
#==========================

# Load data
# # Load GRBI rasterized spatialPoints
GRBI_points <- readRDS("./data_clean/GRBI_rasterPoints_sQ.RDS")

# # Explana_dat
explana_dat <- readRDS("./SDM/explana_dat.RDS")

# # SpacePoly
spacePoly <- readRDS("./SDM/spacePoly.RDS")

# Reduce computing time by limiting extent
xmin <- -71.5
xmax <- -64
ymin <- 48
ymax <- 49.5

# Generate extent object
extent <- raster::extent(xmin, xmax, ymin, ymax)

# Crop GRBI rasterized occurences
GRBI_points <- raster::crop(GRBI_points, extent)

# Crop explanatory data
explana_dat <- raster::crop(explana_dat, GRBI_points)
spacePoly <- raster::crop(spacePoly, GRBI_points)

# Check data
raster::plot(explana_dat[[12]]); points(GRBI_points, pch=19, cex=0.2)

# Mesh
regionBorder <- raster::extent(explana_dat)
xyBasis <- rbind(cbind(c(raster::xmin(explana_dat),raster::xmax(explana_dat),
                         raster::xmin(explana_dat),raster::xmax(explana_dat)),
                       c(raster::ymin(explana_dat),raster::ymax(explana_dat), 
                         raster::ymax(explana_dat),raster::ymin(explana_dat))),
                 raster::coordinates(GRBI_points)[,1:2])
Mesh <- inla.mesh.2d(loc.domain = xyBasis,
                     max.edge = 0.55,
                     min.angle = 20,
                     cutoff = 0.5,
                     offset = c(2,1),
                     crs = crs(explana_dat))

#
explana <- explanaMesh(sPoly = spacePoly, 
                       mesh = Mesh, 
                       X = explana_dat)

# 
weight <- ppWeight(sPoly = spacePoly, mesh = explana$mesh)

# Save simplified data
save(GRBI_points, explana, weight, spacePoly, file = "./SDM/fast_data.RData")

raster::writeRaster(explana$X, "./SDM/explana$X_fast_data.tif", format="raster", bandorder='BIL', overwrite=TRUE)

