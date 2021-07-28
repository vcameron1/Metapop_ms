
#====
# Data from: https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/DONNEES_FOR_ECO_SUD/Resultats_inventaire_et_carte_ecofor/
## _NC files were selected when available
#====

library("RSQLite")
library("sf")

setwd("~/Documents/Git/Metapop_ms")

# List feuillets
feuillets <- c("31H", "31I", "31P", "32A", "32H",
               "21E", "21M", "21L", "22D", "22E",
               "21K", "21N", "22C", "22F", 
               "21O", "22B", "22G",
               "22A", "22H")
feuillets_low <- tolower(feuillets)


#### Join all feuillets ####

# Import data file
f250 <- sf::read_sf(paste0("~/Downloads/PRODUITS_IEQM_23B_GPKG/PRODUITS_IEQM_",feuillets[1],".gpkg"), layer="pee_ori")

j=nrow(f_250)
f_250$feuillet <- rep(feuillets[1],nrow(f_250))
for(i in 2:length(feuillets)){
  
  # import data
  f <- sf::read_sf(paste0("~/Downloads/PRODUITS_IEQM_23B_GPKG/PRODUITS_IEQM_",feuillets[i],".gpkg"), layer="pee_ori")
  
  j=j+nrow(f)
  
  # Join data
  if(st_crs(f) != st_crs(f_250)) st_crs(f) <- st_crs(f_250) # Solve crs compatibility issues
  f_250 <- rbind(f_250, f)
  
  print(feuillets[i])
}
print(j)

# Save data
saveRDS(f_250, "./data/f_250.RDS")



#### From sf to raster ####

f250 <- readRDS("./data/f_250.RDS"); colnames(f250)
f250 <- f250[,c("type_couv","cl_dens","cl_haut","feuillet","geom")]

# South of Québec map limits
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5

# Crop data to sampling region
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits
r <- raster::crop(r, e)

# Transform f250 to LatLong coordinate system
## f250_22B fails to correctly transform 
f250_trans <- sf::st_transform(f250, raster::crs(r)) 


# Convert codes to numeric data
# Required by fasterize()
unique(f250_trans$type_couv)
f250_trans$type_couv[f250_trans$type_couv==" "] <- NA
f250_trans$type_couv[f250_trans$type_couv=="F"] <- 1
f250_trans$type_couv[f250_trans$type_couv=="M"] <- 2
f250_trans$type_couv[f250_trans$type_couv=="R"] <- 3
f250_trans$type_couv <- as.numeric(f250_trans$type_couv)

unique(f250_trans$cl_dens)
f250_trans$cl_dens[f250_trans$cl_dens==" "] <- NA
f250_trans$cl_dens[f250_trans$cl_dens=="A"] <- 1
f250_trans$cl_dens[f250_trans$cl_dens=="B"] <- 2
f250_trans$cl_dens[f250_trans$cl_dens=="C"] <- 3
f250_trans$cl_dens[f250_trans$cl_dens=="D"] <- 4
f250_trans$cl_dens[f250_trans$cl_dens=="H"] <- 8
f250_trans$cl_dens[f250_trans$cl_dens=="I"] <- 9
f250_trans$cl_dens <- as.numeric(f250_trans$cl_dens)

unique(f250_trans$cl_haut)
f250_trans$cl_haut <- as.numeric(f250_trans$cl_haut)

# Rasterize forest cover data
#forestCover <- raster::rasterize(f250_trans, r) # Too long
f250_type_couv.raster <- fasterize::fasterize(f250_trans, r, field="type_couv") # Faster
f250_cl_dens.raster <- fasterize::fasterize(f250_trans, r, field="cl_dens") # Faster
f250_cl_haut.raster <- fasterize::fasterize(f250_trans, r, field="cl_haut") # Faster
f250.stack <- raster::stack(f250_type_couv.raster,f250_cl_dens.raster,f250_cl_haut.raster)
names(f250.stack) <- c("type_couv","cl_dens","cl_haut")
saveRDS(f250.stack, "./data/forestCover_raster.RDS")


#### Metadata ####
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

# ges_co: groupements d’essences des peuplements

# cag_co: Codes des classes d’âge selon la structure des peuplements

# lp_co: Codes des classes de pente

# dsu_co: Codes des épaisseurs de dépôts de surface en usage pour la photo- interprétation à l’échelle de 1/15 

# tec_co_tec: Type écologiq e +Type de dépôt et de drainage de la station +  Situation topographique


# ter_co: Classement des éléments de territoire dans les catégories de terrains
