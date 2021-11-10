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

SDM.glm <- function(template, BITH, covariables = ".", pred, nquad = 10000, quadOverlay = TRUE, nquadWanted = FALSE){
  # quadOverlay if true, quadrature points are randomly placed, if false, those overlaying GRBI points are excluded
    
    # Find the area (km2) of the survey region
    areaRegion <- sum(raster::values(template), na.rm=TRUE) * 0.25 * 0.25

    # Define random samples
    set.seed(12)
    # # Candidate cells within region
    candidates <- seq_along(pred$temp)[!is.na(raster::values(template))]
    # # Reject those where there are BTIH points (if option selected)
    if(!quadOverlay) candidates <- seq_along(pred$temp)[!is.na(raster::values(template)) & is.na(BITH[,2])]
    # # Select nquad cells
    quadSel <- sample(candidates, nquad, replace = FALSE)
    
    # Organise coordinates
    spQuadCell <- c(which(!is.na(BITH[,2])), quadSel)
    
    # Extract variables
    datSpQuad <- pred[spQuadCell,]
    
    # Build response variable
    spQuad <- c(rep(1, length(which(BITH[,2] == 1))), rep(0, nquad))

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
        predQuad <- datSpQuad[-(seq_along(which(BITH[,2] == 1))),]
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

SDM.plot <- function(template, model, newdata, logPred = TRUE, BITH, points = TRUE, ...){


    if(length(names(newdata)) == 1) names(dat) <- "datSpQuad"
    intensityMap <- predict(model,
                            newdata = newdata,
                            type = "response")
    
    # Build the raster objects
    prediction <- template
    raster::values(prediction) <- intensityMap

    # Draw the map
    colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)

    dev.new()
    par(mar=c(0,0,2,0))
    if(!logPred){
      raster::plot(prediction, col = colo,  zlim = c(0, max(raster::values(prediction), na.rm = TRUE)), axes = FALSE, box = FALSE, bg = "grey", ...)
    }else{
      prediction[prediction < 0.01] <- 0.01
      logpred <- log(prediction)
      logpred[prediction == -Inf] <- 0
      raster::plot(logpred, col = colo,  zlim = c(-5,10), axes = FALSE, box = FALSE, bg = "grey", ...)
      print("Intensity predictions were log-transformed")
    }
    
    if(points){
      BITH_points <- template
      raster::values(BITH_points) <- BITH
      points(raster::coordinates(BITH_points), pch = 3, cex = 0.05)}

}


#==========================
# Function to compute GLM model AUC
#==========================

SDM.AUC <- function(model, newdata, BITH, RL_cutoff, template, plot_prediction = FALSE, points = FALSE,...){
  
  # Projection of the model from new data
  if(length(names(newdata)) == 1) names(newdata) <- "datSpQuad"
  pred <- predict(model, newdata = newdata, type = "response")

  # Projected distribution raster
  pred[pred >= RL_cutoff] <- 1
  pred[pred < RL_cutoff] <- 0
  r <- template
  raster::values(r) <- pred
  
  # Plot prediction
  if(plot_prediction){
    #dev.new()
    raster::plot(r, axes = FALSE, box = FALSE, legend = FALSE, ...) 
    if(points) {
      BITH_points <- template
      raster::values(BITH_points) <- BITH$x
      BITH_points[BITH_points==0] <- NA
      BITH_points <- raster::rasterToPoints(BITH_points) # Keep cell centroids
      BITH_points <- sp::SpatialPoints(BITH_points, proj4string = raster::crs(template))
      points(BITH_points, pch = 3, cex = 0.05)}
  }

  # Compute AUC 
  response <- BITH$x
  response[raster::values(template)==1 & is.na(response)] <- 0
  pROC::auc(response, pred) # Observed vs predicted
}

