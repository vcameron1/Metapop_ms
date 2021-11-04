# Climate warming projections
## Requires the object "model" from GRBI_SDM.R


# 1 - Projections ---------------------------------------------------------


if(false){
  # Load RCP45 projections
  RCP45_2020_df <- read.csv("./SDM/RCP45_2020_df.csv")
  RCP45_2040_df <- read.csv("./SDM/RCP45_2040_df.csv")
  RCP45_2070_df <- read.csv("./SDM/RCP45_2070_df.csv")
  RCP45_2100_df <- read.csv("./SDM/RCP45_2100_df.csv")

  # Load biomass projections
  biomass_2020_df <- read.csv("./SDM/biomass_2020_df.csv")
  biomass_2040_df <- read.csv("./SDM/biomass_2040_df.csv")
  biomass_2070_df <- read.csv("./SDM/biomass_2070_df.csv")
  biomass_2100_df <- read.csv("./SDM/biomass_2100_df.csv") 
}

# Load model
load("./SDM/BITH_SDM.RData")

# Scenarios
scenarios <- c("RCP45_2020", "RCP45_2040", "RCP45_2070", "RCP45_2100",
               "biomass_2020", "biomass_2040", "biomass_2070", "biomass_2100")

# Compute predictions per scenario
for (i in seq_along(scenarios)) {

  # # Load data
  ## Reduces greatly the pressure on the memory
  dat <- read.csv(paste0("./SDM/",scenarios[i], "_df.csv"))

  # # Predict according to scenario
  intensityMap <- predict(model,
                            newdata = dat,
                            type = "response")

  # # Save projection
  write.csv(intensityMap, paste0("./SDM/results/BITH_", scenarios[i], ".csv"))
  
  # # Build the raster objects
  prediction <- raster::raster(explana_scenario[["temp"]]) 
  raster::values(prediction) <- intensityMap

  # # Log predictions
  prediction[prediction < 0.01] <- 0.01
  logpred <- log(prediction)
  logpred[prediction == -Inf] <- 0

  # # Stack
  if(i == 1){ 
    BITH_2020_2100 <- logpred
    }else{
      BITH_2020_2100 <- raster::addLayer(BITH_2020_2100, logpred)
    }

  # # Name layer
  names(BITH_2020_2100)[[i]] <- paste0(scenarios[i])
}

# Save predictions
filenames <- paste0("./SDM/results/BITH_", names(BITH_2020_2100), ".tif")
raster::writeRaster(BITH_2020_2100, filename=filenames, bylayer=TRUE, overwrite=TRUE)


# 2 - Patch metrics -------------------------------------------------------


# Dependencies
source("./SDM/patch_metrics_functions.R")

# Compute patch metrics over full distribution
# # Limit analysis to current distribution
e <- raster::extent(c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143))
RCP45_QC <- raster::crop(RCP45, e)
metrics_RCP45_QC <- patch.metrics(RCP45_QC, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_RCP45_QC, "./SDM/results/BITH_metrics_RCP45_QC.RDS")

# Patch metrics over EasternTownships
e_ET <- raster::extent(c(xmin = -356488, xmax = -115085, ymin = 111680, ymax = 234873))
RCP45_ET <- raster::crop(RCP45, e_ET)
metrics_RCP45_ET <- patch.metrics(RCP45_ET, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_RCP45_ET, "./SDM/results/metrics_RCP45_ET.RDS")

# Patch metrics over Réserve faunique des Laurentides
e_RL <- raster::extent(c(xmin = -282986, xmax = -109983, ymin = 311761, ymax = 475079))
RCP45_RL <- raster::crop(RCP45, e_RL)
metrics_RCP45_RL <- patch.metrics(RCP45_RL, RL_cutoff = 0.05, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_RCP45_RL, "./SDM/results/metrics_RCP45_RL.RDS")


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


