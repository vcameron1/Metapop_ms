# Climate warming projections


# 1 - Projections ---------------------------------------------------------


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

  # # Name layer
  names(SDM_GRBI)[[i]] <- paste0(cc[i])
}

# Save projections
saveRDS(SDM_GRBI, "./SDM/results/projections_GRBI.RDS")


# 2 - Patch metrics -------------------------------------------------------


# Dependencies
source("./SDM/patch_metrics.R")

# Wrapper to use patch.metrics function over all temperature predictions
get.metrics <- function(rasterPred, RL_cutoff = 0.05, cc = cc){
  metrics_list <- list()
  for(i in seq_along(cc)){
  metrics <- patch.metrics(rasterPred[[i]], RL_cutoff = RL_cutoff)
  metrics_list[[i]] <- metrics
  }
  return(metrics_list)
}

# Compute patch metrics over full distribution
# # Limit analysis to current distribution
e <- raster::extent(c(xmin = -75, xmax = -64, ymin = 45, ymax = 49.5))
SDM_QC <- raster::crop(SDM_GRBI, e)
metrics_QC <- get.metrics(SDM_QC, RL_cutoff = 0.05, cc = cc)
#saveRDS(metrics_QC, "./SDM/results/metrics_QC.RDS")

# Patch metrics over EasternTownships
e_ET <- raster::extent(c(xmin = -73, xmax = -70, ymin = 45, ymax = 46))
SDM_ET <- raster::crop(SDM_GRBI, e_ET)
metrics_ET <- get.metrics(SDM_ET, RL_cutoff = 0.05, cc = cc)
#saveRDS(metrics_ET, "./SDM/results/metrics_ET.RDS")

# Patch metrics over forêt Montmorency
e_M <- raster::extent(c(xmin = -72.2, xmax = -70, ymin = 46.8, ymax = 48.2))
SDM_M <- raster::crop(SDM_GRBI, e_M)
metrics_M <- get.metrics(SDM_M, RL_cutoff = 0.05, cc = cc)
#saveRDS(metrics_M, "./SDM/results/metrics_M.RDS")


# 3 - Plot predictions ----------------------------------------------------


# Function to plot climate warming as a gif
library(animation)
plot.gif <- function(raster, file.name, xlim, ylim,
                     frames.interval = 0.05, zlim = c(-5,10), ...){
  colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)
  par(mar=c(0,0,0,0))
  ani.options(interval = frames.interval)
  saveGIF({
    for (i in 1:raster::nlayers(raster)){
      raster::plot(raster[[i]], col = colo, maxpixels = raster::ncell(raster),  
                   zlim = zlim, axes = FALSE, box = FALSE, legend = FALSE, 
                   xlim = xlim, ylim = ylim, ...)
    }
  }, 
  movie.name = file.name) 
}

# Gif for EasternTownships
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_ET.gif", xlim=c(-73,-70), ylim=c(45,46),
        frames.interval = 0.05, zlim = c(-5,10), main = "")

# Gif for Forêt Montmorency
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_Montmo.gif", xlim=c(-72.2,-70), ylim=c(46.8,48.2), 
         frames.interval = 0.05, zlim = c(-5,10), main = "")


