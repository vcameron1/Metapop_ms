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


# Rasterized GRBI occurences for south of Québec
GRBI_points <- readRDS("./data_clean/GRBI_rasterPoints_sQ.RDS")

# Explanatory variables
explana_dat <- readRDS("./SDM/explana_dat.RDS")
## Square temperature
explana_dat[["temp2"]] <- explana_dat[["temp"]]
raster::values(explana_dat[["temp2"]])<- raster::values(explana_dat[["temp"]])^2

# Polygon of the region boundaries
spacePoly <- readRDS("./SDM/spacePoly.RDS")


# 2 - Explore data --------------------------------------------------------


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


# 4 - Model ---------------------------------------------------------------

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
# Hypothesys
## 3. T, P, elevation, and forest cover are important and climat interacts with elevation : "bio1 * bio12 * elevation + type_couv + cl_dens + cl_haut"
##################

# Model fomula
cov <- c("temp * temp2 * prec * elevation + type_couv + cl_dens + cl_haut") 

# Downweighted poisson regression (point process model)
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
SDM.AUC(model, newdata=explana_dat, GRBI_points=GRBI_points, RL_cutoff = 0.05, plot_prediction = FALSE)


# 6 - Test model ----------------------------------------------------------


# Temperature gradient
temp <- seq(from=min(raster::values(explana_dat[["temp"]]), na.rm = TRUE), to=max(raster::values(explana_dat[["temp"]]), na.rm = TRUE), length.out=100)
temp2 <- temp^2

# Fix other variables
dat <- as.data.frame(raster::values(explana_dat))[1:100,]
dat$prec <- mean(raster::values(explana_dat[["prec"]]), na.rm = TRUE)
dat$type_couv <- 1
dat$cl_dens <- 1
dat$cl_haut <- 7
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
plot(y = log(intensity[[length(elev)]]), x = dat$temp, col = colo[length(elev)],ylab="log(intensity)", type="l",
    xlab = "Temperature (°C)")
for(i in 1:(length(elev)-1)){
  lines(y = log(intensity[[i]]), x = dat$temp, col=colo[i])
}
legend(3.6, 14, legend = elev, fill = colo, ncol = 2, title = "Elevation (m)", bty = 'n')

