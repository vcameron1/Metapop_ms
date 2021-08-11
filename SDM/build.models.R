build.models <- function(){
  
  # 0 - Setup ---------------------------------------------------------------
  
  
  set.seed(123)
  
  # Load mapSpecies package locally
  devtools::load_all("./mapSpecies/")
  library(mapSpecies)
  
  library(raster)
  
  
  # 1 - Load data -----------------------------------------------------------
  
  
  # Load GRBI data
  GRBI <- readxl::read_excel("./data_raw/RAPPORT QO_SOS-POP SCF_GRBI.xlsx", sheet = 2)
    
  # Elevation data
  elevation <- readRDS("./data_clean/elev_sQ.RDS")
  
  # explanatory variables
  explana_dat <- readRDS("./SDM/explana_dat.RDS")
  
  # spacePoly
  spacePoly <- readRDS("./SDM/spacePoly.RDS")
  
  # explana
  explana <- readRDS("./SDM/explana.RDS")
  
  # 2 - Clean GRBI data -----------------------------------------------------
  
  
  # Select one observation/occurence per PRÉCISION == "S"
  GRBI <- GRBI[GRBI$PRÉCISION == "S",]
  
  # Remove recordings of absences
  GRBI <- GRBI[GRBI$O_CODEATLA != "0",]
  
  # Select presence in habitat 
  #GRBI <- GRBI[GRBI$O_CODEATLA == c("H"),]
  
  # Select one observation per coordinate per year (after 2000)
  annee <- unique(GRBI$ANNEE)
  annee <- annee[annee >= 2000]
  GRBI$lat <- round(GRBI$LATITUDE, 2)
  GRBI$lon <- round(GRBI$LONGITUDE, 2)
  
  GRBI2 <- data.frame()
  for(i in sort(annee)){
    for(j in unique(GRBI$lat)){
      for(k in unique(GRBI$lon)){
        obs <- which(GRBI$ANNEE == i &
                       GRBI$lat == j &
                       GRBI$lon == k)
        
        if(length(obs)>0) GRBI2 <- rbind(GRBI2, GRBI[obs[1],])
      }
    }
    cat(i, ": complété\n")
  }
  GRBI <- GRBI2
  rm("GRBI2")
  
  # Crop GRBI presence data
  GRBI <- GRBI[GRBI$LONGITUDE>=xmin(elevation) & 
                 GRBI$LONGITUDE<=xmax(elevation) & 
                 GRBI$LATITUDE>=ymin(elevation) & 
                 GRBI$LATITUDE<=ymax(elevation),]
rm("elevation")
  
  # 2 - Format predictors ---------------------------------------------------
  
  
  # Select GRBI points within the region of interest
  GRBI_points <- SpatialPoints(cbind(GRBI$LONGITUDE, GRBI$LATITUDE),
                               proj4string = spacePoly@proj4string)
    
  # 5 - Calculate weights associated to each edges of the mesh --------------
  
  
  weight <- ppWeight(sPoly = spacePoly, mesh = explana$mesh)
  rm("spacePoly")
  
   
  # 6 - Buid the models -----------------------------------------------------
  
  
  # Spatial model
  if(!"modelPPspatial.RDS" %in% dir("./SDM/results")){
    modelPPspatial <- ppSpace(y ~ 0, sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
    saveRDS(modelPPspatial, "./SDM/results/modelPPspatial.RDS")
  }
   
  # Full model
  if(!"modelPP.RDS" %in% dir("./SDM/results")){
    modelPP <- ppSpace(y ~ ., sPoints = GRBI_points,
                       explanaMesh = explana,
                       ppWeight = weight,
                       many = TRUE,
                       control.compute = list(waic = TRUE))
    saveRDS(modelPP, "./SDM/results/modelPP.RDS")
  }
   
  # Full model without elevation
  if(!"modelPPnoElev.RDS" %in% dir("./SDM/results")){
    formu <- as.formula(paste("y", paste0(names(explana_dat)[names(explana_dat) != "elevation"], collapse = "+"), sep = "~"))
    modelPPnoElev <- ppSpace(formu, 
                             sPoints = GRBI_points,
                             explanaMesh = explana,
                             ppWeight = weight,
                             many = TRUE,
                             control.compute = list(waic = TRUE))
    saveRDS(modelPPnoElev, "./SDM/results/modelPPnoElev.RDS")
  }
 
  # Climate only model
  if(!"modelPPclim.RDS" %in% dir("./SDM/results")){
    formu <- as.formula(paste("y", paste0(paste0("bio", 1:19), collapse = "+"), sep = "~"))
    modelPPclim <- ppSpace(formu, 
                           sPoints = GRBI_points,
                           explanaMesh = explana,
                           ppWeight = weight,
                           many = TRUE,
                           control.compute = list(waic = TRUE))
    saveRDS(modelPPclim, "./SDM/results/modelPPclim.RDS")
  }
   
  # Forest interaction model
  if(!"modelPPforest.RDS" %in% dir("./SDM/results")){
    modelPPforest <- ppSpace(y ~ type_couv*cl_haut*cl_dens, 
                             sPoints = GRBI_points,
                             explanaMesh = explana,
                             ppWeight = weight,
                             many = TRUE,
                             control.compute = list(waic = TRUE))
    saveRDS(modelPPforest, "./SDM/results/modelPPforest.RDS")
  }

  # Interaction elevation~climate model
  if(!"modelPPelevBio.RDS" %in% dir("./SDM/results")){
    formu <- as.formula(paste(paste("y", paste0(names(explana_dat), collapse = "+"), sep = "~"), " + elevation:bio1"))
    modelPPelevBio <- ppSpace(formu,
                              sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
    saveRDS(modelPPelevBio, "./SDM/results/modelPPelevBio.RDS")
  }

  # type_couv interaction model
  if(!"modelPPtypeCouv.RDS" %in% dir("./SDM/results")){
    formu <- as.formula(y ~ elevation*type_couv + bio1*type_couv + bio12)
    modelPPtypeCouv <- ppSpace(formu,
                              sPoints = GRBI_points,
                              explanaMesh = explana,
                              ppWeight = weight,
                              many = TRUE,
                              control.compute = list(waic = TRUE))
    saveRDS(modelPPtypeCouv, "./SDM/results/modelPPtypeCouv.RDS")
  }

}

