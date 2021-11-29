################
# This script deals with presence only data
# Victor Cameron
# 30/07/21
# Modified August 2021
###############

# The code in this script is adapted from Guillaume Blanchet work for the 2019 biodiversity modeling summer school


# 0 - Load dependences ----------------------------------------------------


source("./SDM/SDM_functions.R")


# 1 - Load data -----------------------------------------------------------


# Rasterized BITH occurences for south of Québec
BITH <- data.table::fread("./data_clean/GRBI_rasterized.csv")
#GRBI_points <- readRDS("./data_clean/GRBI_rasterPoints.RDS")

# Explanatory variables
#explana_dat <- read.csv("./SDM/explana_dat_df.csv")
explana_dat <- data.table::fread("./SDM/explana_dat_df.csv")

# Template
template <- raster::raster("./data_clean/templateRaster.tif")

# Polygon of the region boundaries
#spacePoly <- rgdal::readOGR(dsn = "./SDM", layer = "spacePoly")
#spacePoly <- readRDS("./SDM/spacePoly.RDS")


# 2 - Explore data --------------------------------------------------------


if(false){
  names(explana_dat)
  dev.new()

  # Rasterize GRBI occurences
  GRBI_r <- raster::rasterize(raster::coordinates(GRBI_points)[,1:2], explana_dat[["temp"]], fun='count', background=0)

  # temp : mean annual temperature
  hist(raster::values(explana_dat[["temp"]])) 
  boxplot(raster::values(explana_dat[["temp"]]) ~ raster::values(GRBI_r))

  # prec : mean total annual precipitations
  hist(raster::values(explana_dat[["prec"]])) 
  boxplot(raster::values(explana_dat[["prec"]]) ~ raster::values(GRBI_r))

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
}


# 3 - Likelihood for different numbers of quadrature points ---------------


if(false){
  # Select the number of quadrature points with saturated model
  set.seed(123)
  n.quad = c(1000, 5000, 10000, 50000, 100000, 500000, 1000000) # Model does not converge with > 1000000 quadrature points

  for(i in 1){
      loglik = rep(NA, length(n.quad))

      for(j in 1:length(n.quad)){
      res <- SDM.glm(template=template,
                    BITH=BITH,
                    covariables = c("temp + temp2 + prec + elevation + abie.balPropBiomass + abie.balBiomass"), 
                    pred = explana_dat[,-"V1"],
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
}


# 4 - Model ---------------------------------------------------------------

##################
# Habitat requirements of GRBI accoring to COSEWIC
## Habitat specialist
## 1. High elevation coniferous forests (windy, dense, naturally perturbed, coniferous, fir)
## 2. lowland coastal forests (rainy, windy, dense, naturally perturbed, coniferous, fir)
## 3. indistrial forests of the north (dense, perturbed, coniferous, fir)
## dense fir forests non-perturbed
## perturbed fir forest in regeneration
## Altitude is an important factor: 450m-1000m minimum, and descends with latitude
## RL coincides with Mixed forest - boreal forest ecotone
## Habitat variables: fir density, latitude, longitude, altitude (Lambert et al. 2005, Hart)
##################

##################
# Hypothesys
## 3. T, P, elevation, and forest cover are important and climat interacts with elevation : "bio1 * bio12 * elevation + type_couv + cl_dens + cl_haut"
##################

# Model fomula
#cov <- c("temp * temp2 * prec * elevation + type_couv + cl_dens + cl_haut")
#cov <- c("temp * temp2 * prec * elevation + abie.balPropBiomass * abie.balBiomass")
cova <- c("temp + temp2 + prec + elevation + abie.balPropBiomass * abie.balBiomass")


# Check VIF (colinearity)
#VIF>2-3 is ok
source("./SDM/vif.R")
mat <- model.matrix(formula(paste0("~ ", cova)), explana_dat)
vif <- vif(mat[,-1])

# Downweighted poisson regression (point process model)
res <- SDM.glm(template=template,
                  BITH=BITH,
                  covariables = cova,
                  pred = explana_dat,
                  nquad = 5000000,
                  quadOverlay = TRUE,
                  nquadWanted = FALSE,
                  seed = 12)
model <- res[["model"]]
#saveRDS(model, "./SDM/BITH_SDM.RDS")
summary(model)

# Best intensity cutoff value to set the breeding range limit
RL_cutoff <- 0.00625 # 1 indv / km2

# Plot predictions
SDM.plot(template, model, newdata = explana_dat, logPred = TRUE, BITH, points = TRUE, main = "GLM prediction (log)")
# Predictions for Eastern Townships
SDM.plot(model, newdata = explana_dat, logPred = TRUE, GRBI_points, points = FALSE, main = "GLM prediction EasternTownships (log)", xlim=c(-73,-70), ylim=c(45,46))
SDM.AUC(model, newdata=explana_dat, BITH=BITH, RL_cutoff = RL_cutoff, template = template, plot_prediction = TRUE)


# 6 - Test model ----------------------------------------------------------


#########################
# Functions to test model
#########################

model.elevBehavior <- function(model, explana_dat, RL_cutoff = NULL, ...){
    # Temperature gradient
    temp <- seq(from=min(explana_dat[["temp"]], na.rm = TRUE), to=max(explana_dat[["temp"]], na.rm = TRUE), length.out=100)
    temp2 <- temp^2

    # Fix other variables
    dat <- explana_dat[1:100,]
    dat$prec <- mean(explana_dat[["prec"]], na.rm = TRUE)
    dat$abie.balPropBiomass <- 0.5#mean(explana_dat[["abie.balPropBiomass"]], na.rm = TRUE)
    dat$abie.balBiomass <- 30#mean(explana_dat[["abie.balBiomass"]], na.rm = TRUE)
    dat$temp <- temp
    dat$temp2 <- temp2
    elev <- seq(500, 1200, by = 25)

    # Predict
    intensity <- list()
    for(i in 1:length(elev)){
    dat$elevation <- elev[i]
    intensity[[i]] <- predict(model, newdata = dat, type = "response")
    }

    # Cols
    colo <- colorRampPalette(c("grey90", "steelblue4", 
                            "steelblue2", "steelblue1", 
                            "gold", "red1", "red4"))(length(elev))

    # Plot prediction
    plot(y = log(intensity[[length(elev)]]), x = dat$temp, col = colo[length(elev)], ylab="log(intensity)", type="l", xlab = "Temperature (°C)", ...)
    polygon(x = c(min(explana_dat[["temp"]], na.rm = TRUE), -2, -2, min(explana_dat[["temp"]], na.rm = TRUE)),                           # X-Coordinates of polygon
        y = c(-10000, -10000, 10000, 10000),                             # Y-Coordinates of polygon
        col = rgb(211,211,211, max=255, alpha=127),
        border=rgb(211,211,211, max=255, alpha=127))   
    for(i in 1:(length(elev)-1)){
    lines(y = log(intensity[[i]]), x = dat$temp, col=colo[i])
    }
    if(!is.null(RL_cutoff)) abline(h = log(RL_cutoff), lty = 2, col = "black")
    legend(3.6, max(log(unlist(intensity))), legend = elev, fill = colo, ncol = 2, title = "Elevation (m)", bty = 'n', cex = 0.5)
}

model.biomassBehavior <- function(model, explana_dat, RL_cutoff = NULL, ...){
    # Temperature gradient
    temp <- seq(from=min(explana_dat[["temp"]], na.rm = TRUE), to=max(explana_dat[["temp"]], na.rm = TRUE), length.out=100)
    temp2 <- temp^2

    # Fix other variables
    dat <- explana_dat[1:100,]
    dat$prec <- mean(explana_dat[["prec"]], na.rm = TRUE)
    abie.balPropBiomass <- seq(0,1,le=8)
    dat$abie.balBiomass <- 30
    dat$temp <- temp
    dat$temp2 <- temp2
    dat$elevation <- 750

    # Predict
    intensity <- list()
    for(i in 1:length(abie.balPropBiomass)){
    dat$abie.balPropBiomass <- abie.balPropBiomass[i]
    intensity[[i]] <- predict(model, newdata = dat, type = "response")
    }

    # Cols
    colo <- colorRampPalette(c("grey90", "steelblue4", 
                            "steelblue2", "steelblue1", 
                            "gold", "red1", "red4"))(length(abie.balPropBiomass))

    # Plot prediction
    plot(y = log(intensity[[length(abie.balPropBiomass)]]), x = dat$temp, col = colo[length(abie.balPropBiomass)], ylab="log(intensity)", type="l", xlab = "Temperature (°C)", ylim = c(min(log(unlist(intensity))),max(log(unlist(intensity)))), ...)
    polygon(x = c(min(explana_dat[["temp"]], na.rm = TRUE), -2, -2, min(explana_dat[["temp"]], na.rm = TRUE)),                           # X-Coordinates of polygon
        y = c(-10000, -10000, 10000, 10000),                             # Y-Coordinates of polygon
        col = rgb(211,211,211, max=255, alpha=127),
        border=rgb(211,211,211, max=255, alpha=127))   
    for(i in 1:(length(abie.balPropBiomass)-1)){
    lines(y = log(intensity[[i]]), x = dat$temp, col=colo[i])
    }
    if(!is.null(RL_cutoff)) abline(h = log(RL_cutoff), lty = 2, col = "black")
    legend(3.6, max(log(unlist(intensity)), na.rm=T), legend = round(abie.balPropBiomass,1), fill = colo, title = "propBiomass", bty = 'n', cex = 0.5)
}


#########################
# Test model 
#########################

model.elevBehavior(model, explana_dat, RL_cutoff = RL_cutoff)
model.biomassBehavior(model, explana_dat, RL_cutoff = RL_cutoff)
