#############################################################
## Generate a forest cover raster* for the south of Quebec
## Victor Cameron 
## July 2021
#############################################################


# 1 - Transform polygons into raster* objects -----------------------------


# Import data
#r <- readRDS("./data_clean/elev_sQ.RDS") # Used as the raster* template 
f250 <- readRDS("./data_clean/f_250.RDS")
f250 <- f250[,c("type_couv","cl_dens","cl_haut","feuillet","geom")]

# Convert char codes to numeric data
# Required by fasterize::fasterize()
couvCode <- c("R", "M", "F")
f250$type_couv <- sapply(f250$type_couv, function(char) match(char, couvCode))
#=====
# Résineux: R -> 1
# Feuillu:  F -> 2
# Mélangé:  M -> 3
#=====

f250$cl_dens <- sapply(f250$cl_dens, function(char) match(char, toupper(letters)))
#=====
# A: >80%   -> 1
# B: 60-80% -> 2
# C: 40-60% -> 3
# D: 25-40% -> 4
#=====

f250$cl_haut <- as.numeric(f250$cl_haut)
#=====
# 1: >22m
# 2: 17-22m
# 3: 12-17m
# 4: 7-12m
# 5: 7-4m
# 6: 2-4m
# 7: <2m
#=====

# Rasterize forest cover data
r <- readRDS("./data_clean/templateRaster_sQ.RDS") # LatLong limits

#f250_type_couv.raster <- raster::rasterize(f250, r, field="type_couv") # Too long
f250_type_couv.raster <- fasterize::fasterize(sf::st_sf(f250), r, field="type_couv") # Faster
f250_cl_dens.raster <- fasterize::fasterize(sf::st_sf(f250), r, field="cl_dens") # Faster
f250_cl_haut.raster <- fasterize::fasterize(sf::st_sf(f250), r, field="cl_haut") # Faster
f250.stack <- raster::stack(f250_type_couv.raster,f250_cl_dens.raster,f250_cl_haut.raster)
names(f250.stack) <- c("type_couv","cl_dens","cl_haut")


# 2 - Transform back type_couv values to factors --------------------------


# type_couv
saveRDS(f250.stack, "./data_clean/forestCover_sQ.RDS")
unique(raster::values(f250.stack[["type_couv"]]))
f250.stack[["type_couv"]] <- raster::as.factor(f250.stack[["type_couv"]])
rat <- raster::levels(f250.stack[["type_couv"]])[[1]]
rat$category <- c("R", "M", "F")
levels(f250.stack[["type_couv"]]) <- rat

# cl_dens
unique(raster::values(f250.stack[["cl_dens"]]))
f250.stack[["cl_dens"]] <- raster::as.factor(f250.stack[["cl_dens"]])
rat <- raster::levels(f250.stack[["cl_dens"]])[[1]]
rat$category <- c("A", "B", "C", "D", "I")
levels(f250.stack[["cl_dens"]]) <- rat

# cl_haut
unique(raster::values(f250.stack[["cl_haut"]]))
f250.stack[["cl_haut"]] <- raster::as.factor(f250.stack[["cl_haut"]])
rat <- raster::levels(f250.stack[["cl_haut"]])[[1]]
rat$category <- as.factor(1:7)
levels(f250.stack[["cl_haut"]]) <- rat


# 3 - Save transformed data -----------------------------------------------


# Save data
saveRDS(f250.stack, "./data_clean/forestFactor_sQ.RDS")


# 4 - Metadata ------------------------------------------------------------


# type_couv: Codes des types de couverts
  # # Feuillu = F
  # # Mélangé = M
  # # Résineux = R
  # # " " = tiges<2m ou >7m de hauteur

# cl_dens: classe de densité
  # # A: >80%
  # # B: 60-80%
  # # C: 40-60%
  # # D: 25-40%

# cl_haut: classe de hauteur
  # # 1: >22m
  # # 2: 17-22m
  # # 3: 12-17m
  # # 4: 7-12m
  # # 5: 7-4m
  # # 6: 2-4m
  # # " ": <2m