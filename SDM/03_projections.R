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
model <- readRDS("./SDM/BITH_SDM.RDS")

# Best intensity cutoff value to set the breeding range limit
RL_cutoff <- 0.00625 # 1 indv / km2

# Load template
template <- raster::raster("./data_clean/templateRaster.tif")

# Scenarios
scenarios <- c("RCP45_2020", "RCP45_2040", "RCP45_2070", "RCP45_2100",
               "biomass_2020", "biomass_2040", "biomass_2070", "biomass_2100")

# Compute predictions per scenario
for (i in seq_along(scenarios)) {

  # # Load data
  ## Reduces greatly the pressure on the memory
  dat <- data.table::fread(paste0("./SDM/",scenarios[i], "_df.csv"))


  # # Predict according to scenario
  intensityMap <- predict(model,
                            newdata = dat,
                            type = "response")

  # Remove df from memory
  rm("dat")

  # # Save projection
  #write.csv(intensityMap, paste0("./SDM/results/BITH_", scenarios[i], ".csv"))
  
  # # Build the raster objects
  prediction <- template
  raster::values(prediction) <- intensityMap

  # # Log predictions
  logpred <- log(prediction)

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
filenames <- paste0("./SDM/results/BITH_", scenarios, ".tif")
raster::writeRaster(BITH_2020_2100, filename=filenames, bylayer=TRUE, overwrite=TRUE)


# 2 - Patch metrics -------------------------------------------------------


# If needed, load BITH_2020_2100
if (FALSE){
  BITH_2020_2100 <- raster::raster(filenames[1])
  for (file in filenames[-1]){
    r <- raster::raster(file)
    BITH_2020_2100 <- raster::addLayer(BITH_2020_2100, file)
  }
}

# Dependencies
source("./SDM/patch_metrics_functions.R")

# Compute patch metrics over full distribution
# # Limit analysis to current distribution
e <- raster::extent(c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143))
BITH_2020_2100_QC <- raster::crop(BITH_2020_2100, e)
BITH_metrics_QC <- patch.metrics(BITH_2020_2100_QC, RL_cutoff = RL_cutoff, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(metrics_RCP45_QC, "./SDM/results/BITH_metrics_RCP45_QC.RDS")

# Patch metrics over EasternTownships
e_ET <- raster::extent(c(xmin = -356488, xmax = -115085, ymin = 111680, ymax = 234873))
BITH_2020_2100_ET <- raster::crop(BITH_2020_2100, e_ET)
BITH_metrics_ET <- patch.metrics(BITH_2020_2100_ET, RL_cutoff = RL_cutoff, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(BITH_metrics_ET, "./SDM/results/BITH_metrics_ET.RDS")

# Patch metrics over Réserve faunique des Laurentides
e_RL <- raster::extent(c(xmin = -282986, xmax = -109983, ymin = 311761, ymax = 475079))
BITH_2020_2100_RL <- raster::crop(BITH_2020_2100, e_RL)
BITH_metrics_RL <- patch.metrics(BITH_2020_2100_RL, RL_cutoff = RL_cutoff, a = c(1, 1/5, 1/50, 1/200, 1/500))
#saveRDS(BITH_metrics_RL, "./SDM/results/BITH_metrics_RL.RDS")


# 3 - Plot predictions ----------------------------------------------------


# Function to plot climate warming as a gif
if(!require(magic)) install.packages("magick")

plot.gif <- function(raster, file.name, xlim, ylim, frames.interval = 0.5, zlim = c(-5,10), ...){

  colo <- colorRampPalette(c("grey90", "steelblue4", 
                          "steelblue2", "steelblue1", 
                          "gold", "red1", "red4"))(200)

  # Set min value to lower zlim
  raster[raster<zlim[1]] <- zlim[1]

  par(mar=c(0,0,0,0))
  animation::ani.options(interval = frames.interval)
  animation::saveGIF({
    for (i in 1:raster::nlayers(raster)){
      raster::plot(raster[[i]], col = colo, maxpixels = raster::ncell(raster),  
                   zlim = zlim, axes = FALSE, box = FALSE, legend = FALSE, 
                   xlim = xlim, ylim = ylim, ...)
    }
  }, 
  movie.name = file.name) 
}

# Gif for Québec
plot.gif(BITH_2020_2100[[1:4]], file.name = "BITH_RCP45_QC.gif", xlim=c(-514009,356398), ylim=c(110389,633143), frames.interval = 0.5, zlim = c(-5,5), main = "RCP4.5")
plot.gif(BITH_2020_2100[[5:8]], file.name = "./BITH_biomass_QC.gif", xlim=c(-514009,356398), ylim=c(110389,633143), frames.interval = 0.5, zlim = c(-5,5), main = "biomass")

# Gif for EasternTownships
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_ET.gif", xlim=c(-356488,-115085), ylim=c(111680,234873),
        frames.interval = 0.5, zlim = c(-5,10), main = "")

# Gif for Réserve faunique des Laurentides
plot.gif(SDM_GRBI, file.name = "./SDM/results/GRBI_RL.gif", xlim=c(-282986,-109983), ylim=c(311761,475079), 
         frames.interval = 0.5, zlim = c(-5,10), main = "")
