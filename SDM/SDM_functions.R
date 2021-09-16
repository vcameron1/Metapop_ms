################
# Functions to run and visualize predictions for non spatial SDMs
# Victor Cameron
# 30/07/21
# Modified August 2021
###############


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
    par(mar=c(0,0,2,0))
    if(!logPred){
      raster::plot(prediction, col = colo,  zlim = c(0, max(raster::values(prediction), na.rm = TRUE)), axes = FALSE, box = FALSE, ...)
    }else{
      prediction[prediction < 0.01] <- 0.01
      logpred <- log(prediction)
      logpred[prediction == -Inf] <- 0
      raster::plot(logpred, col = colo,  zlim = c(-5,10), axes = FALSE, box = FALSE, ...)
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

