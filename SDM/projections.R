# Climate warming projections


# Build predictions for +4°C
cc <- seq(0, 4, by = 0.2)
for(i in seq_along(cc)){

  # # New data
  explana_warm <- explana_dat
  raster::values(explana_warm[["mat"]]) <- raster::values(explana_warm[["mat"]]) + cc[i]
  raster::values(explana_warm[["mat2"]])<- raster::values(explana_warm[["mat"]])^2
  dat <- as.data.frame(raster::values(explana_warm))

  # # Predict
  intensityMap <- predict(model,
                            newdata = dat,
                            type = "response")

  # # Build the raster objects
  prediction <- raster::raster(explana_warm[["mat"]]) 
  raster::values(prediction) <- intensityMap

  # # Log predictions
  prediction[prediction < 0.01] <- 0.01
  logpred <- log(prediction)
  logpred[prediction == -Inf] <- 0

  # # Stack
  if(i == 1){ 
    SDM_GRBI <- logpred
    }else{
      SDM_GRBI <- raster::addLayer(SDM_GRBI, logpred)
    }
}

# Plot climate warming as a gif
colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)
par(mar=c(0,0,0,0))
library(animation)
ani.options(interval=.05)
saveGIF({
  for (i in 1:raster::nlayers(SDM_GRBI)){
    raster::plot(SDM_GRBI[[i]], col = colo, maxpixels = raster::ncell(SDM_GRBI),  zlim = c(-5,10), axes = FALSE, box = FALSE, legend = FALSE, main = "")
  }
}, 
movie.name = "./SDM/results/GRBI.gif") 

# Gif for EasternTownships
par(mar=c(0,0,0,0))
saveGIF({
  for (i in 1:raster::nlayers(SDM_GRBI)){
    raster::plot(SDM_GRBI[[i]], col = colo, maxpixels = raster::ncell(SDM_GRBI),  zlim = c(-5,10), axes = FALSE, box = FALSE, legend = FALSE, main = "",
    xlim=c(-73,-70), ylim=c(45,46))
  }
}, 
movie.name = "./SDM/results/GRBI_ET.gif") 


# Gif for Forêt Montmorency
par(mar=c(0,0,0,0))
saveGIF({
  for (i in 1:raster::nlayers(SDM_GRBI)){
    raster::plot(SDM_GRBI[[i]], col = colo, maxpixels = raster::ncell(SDM_GRBI),  zlim = c(-5,10), axes = FALSE, box = FALSE, legend = FALSE, main = "",
    xlim=c(-72.2,-70), ylim=c(46.8,48.2))
  }
}, 
movie.name = "./SDM/results/GRBI_Montmo.gif") 

