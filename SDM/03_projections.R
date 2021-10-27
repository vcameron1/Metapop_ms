# Climate warming projections
## Requires the object "model" from GRBI_SDM.R


# 1 - Projections ---------------------------------------------------------


# Get bioclim projections
bioclim_proj <- readRDS("./data_clean/bioclim_proj_sQ.RDS")

# Get explana_dat
explana_dat <- readRDS("./SDM/explana_dat.RDS")

# Scenarios
scenarios <- c("1981_2010", "RCP45_2011_2040",
               "RCP45_2041_2070", "RCP45_2071_2100")

# Compute predictions per scenario
for (i in seq_along(scenarios)) {

  # # Projected temperature data
  explana_scenario <- explana_dat
  raster::values(explana_scenario[["temp"]]) <- raster::values(bioclim_proj[[paste0("temp_", scenarios[i])]])
  explana_scenario[["temp2"]] <- explana_scenario[["temp"]]
  raster::values(explana_scenario[["temp2"]])<- raster::values(explana_scenario[["temp"]])^2

  # # Projected precipitation data
  raster::values(explana_scenario[["prec"]]) <- raster::values(bioclim_proj[[paste0("prec_", scenarios[i])]])

  # # New data 
  dat <- as.data.frame(raster::values(explana_scenario))

  # # Predict
  intensityMap <- predict(model,
                            newdata = dat,
                            type = "response")

  # # Build the raster objects
  prediction <- raster::raster(explana_scenario[["temp"]]) 
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
  names(SDM_GRBI)[[i]] <- paste0(scenarios[i])
}

# Save projections
saveRDS(SDM_GRBI, "./SDM/results/projections_GRBI.RDS")


# 2 - Patch metrics -------------------------------------------------------


# Dependencies
source("./SDM/patch_metrics.R")

# Compute patch metrics over full distribution
# # Limit analysis to current distribution
e <- raster::extent(c(xmin = -75, xmax = -64, ymin = 45, ymax = 49.5))
SDM_QC <- raster::crop(SDM_GRBI, e)
metrics_QC <- patch.metrics(SDM_QC, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_QC, "./SDM/results/metrics_QC.RDS")

# Patch metrics over EasternTownships
e_ET <- raster::extent(c(xmin = -73, xmax = -70, ymin = 45, ymax = 46))
SDM_ET <- raster::crop(SDM_GRBI, e_ET)
metrics_ET <- patch.metrics(SDM_ET, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_ET, "./SDM/results/metrics_ET.RDS")

# Patch metrics over forêt Montmorency
e_RL <- raster::extent(c(xmin = -72.2, xmax = -70, ymin = 46.8, ymax = 48.2))
SDM_RL <- raster::crop(SDM_GRBI, e_RL)
metrics_M <- patch.metrics(SDM_M, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_M, "./SDM/results/metrics_M.RDS")


# 3 - Plot predictions ----------------------------------------------------


# Function to plot climate warming as a gif
if(!require(magic)) install.packages("magick")
library(animation)
plot.gif <- function(raster, file.name, xlim, ylim,
                     frames.interval = 0.5, zlim = c(-5,10), ...){
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
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_QC.gif", xlim=c(-75,-64), ylim=c(45,49.5),
        frames.interval = 0.5, zlim = c(-5,10), main = "")

# Gif for EasternTownships
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_ET.gif", xlim=c(-73,-70), ylim=c(45,46),
        frames.interval = 0.5, zlim = c(-5,10), main = "")

# Gif for Réserve faunique des Laurentides
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_RL.gif", xlim=c(-72.2,-70), ylim=c(46.8,48.2), 
         frames.interval = 0.5, zlim = c(-5,10), main = "")


