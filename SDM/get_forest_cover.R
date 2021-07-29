#############################################################
## Generate a forest cover raster* for the south of Quebec
## Victor Cameron 
## July 2021
#############################################################

#############################################################
## Data downloaded from: https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/DONNEES_FOR_ECO_SUD/Resultats_inventaire_et_carte_ecofor/
## "_NC" files were selected when available
## The downloaded data are polygons of forest cover at 250m
#############################################################


# 0 - Set directory -------------------------------------------------------


setwd("~/Documents/Git/Metapop_ms")


# 1 - Download data -------------------------------------------------------


# List feuillets to download
feuillets <- c("31H", "31I", "31P", "32A", "32H",
               "21E", "21M", "21L", "22D", "22E",
               "21K", "21N", "22C", "22F", 
               "21O", "22B", "22G",
               "22A", "22H")

# Url to access data
url <- paste0("https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/DONNEES_FOR_ECO_SUD/Resultats_inventaire_et_carte_ecofor/",feuillets,"/PRODUITS_IEQM_",feuillets,"_GPKG.zip")

# Directories and files
dir <- "./data_raw/forest_cover/"
subDir <- paste0("PRODUITS_IEQM_",feuillets,"_GPKG/")
destFile <- paste0(dir, "PRODUITS_IEQM_",feuillets,"_GPKG", ".zip")
file <- paste0("PRODUITS_IEQM_",feuillets,".gpkg")


## 1.1 - Import first file ================================================


# Download data file
dir.create(dir, showWarnings = FALSE)
download.file(url[1], destFile[1], method='curl')

# Unzip file
unzip(destFile[1], exdir = dir)

# Import data file
# # If multiple version of the data is available, select "_NC" version
if(!file[1] %in% dir(paste0(dir, subDir[1]))){ 
  file[1] <- paste0("PRODUITS_IEQM_",feuillets[1],"_NC.gpkg")
} 
# # Read pee_ori layer of file
f_250 <- sf::read_sf(paste0(dir, subDir[1], file[1]), layer="pee_ori")

# Add column to store feuillet id
f_250$feuillet <- rep(feuillets[1],nrow(f_250)) 

# Remove all downloaded files to free memory space
unlink(dir, recursive = TRUE)


## 1.2 - Loop through all remaining files =================================


nrow=nrow(f_250)
for(i in 2:length(feuillets)){
  
  # Download data file
  dir.create(dir, showWarnings = FALSE)
  download.file(url[i], destFile[i], method='curl')
  
  # Unzip file
  unzip(destFile[i], exdir = dir)
  
  # Import data file
  # # If multiple version of the data is available, select "_NC" version
  if(!file[i] %in% dir(paste0(dir, subDir[i]))){ 
    file[i] <- paste0("PRODUITS_IEQM_",feuillets[i],"_NC.gpkg")
  } 
  # # Read pee_ori layer of file
  f <- sf::read_sf(paste0(dir, subDir[i], file[i]), layer="pee_ori")
  
  # Remove all downloaded files to free memory space
  unlink(dir, recursive = TRUE)
  
  # Add feuillet id
  f$feuillet <- rep(feuillets[i],nrow(f)) 
  
  nrow=nrow+nrow(f)
  
  # Join data
  # if(st_crs(f) != st_crs(f_250)) st_crs(f) <- st_crs(f_250) # Solve crs compatibility issues
  f_250 <- rbind(f_250, f)
  
  cat("\nFeuillet ", feuillets[i], ": ", i, " of ", length(feuillets), " completed\n")
}
print(nrow)


# 2 - Save combined data --------------------------------------------------


# Save data
saveRDS(f_250, "./data_clean/f_250.RDS")


# 3 - Transform polygons into raster* objects -----------------------------


# Import data
r <- readRDS("./data_clean/elev_sQ.RDS") # Used as the raster* template 
f250 <- readRDS("./data_clean/f_250.RDS"); colnames(f250)
f250 <- f250[,c("type_couv","cl_dens","cl_haut","feuillet","geom")]

# Convert char codes to numeric data
# Required by fasterize::fasterize()
couvCode <- unique(f250$type_couv[!is.na(f250$type_couv)])
f250$type_couv <- sapply(f250$type_couv, function(char) match(char, couvCode))
f250$cl_dens <- sapply(f250$cl_dens, function(char) match(char, toupper(letters)))
f250$cl_haut <- as.numeric(f250$cl_haut)

# Rasterize forest cover data
#forestCover <- raster::rasterize(f250, r) # Too long
f250_type_couv.raster <- fasterize::fasterize(f250, r, field="type_couv") # Faster
f250_cl_dens.raster <- fasterize::fasterize(f250, r, field="cl_dens") # Faster
f250_cl_haut.raster <- fasterize::fasterize(f250, r, field="cl_haut") # Faster
f250.stack <- raster::stack(f250_type_couv.raster,f250_cl_dens.raster,f250_cl_haut.raster)
names(f250.stack) <- c("type_couv","cl_dens","cl_haut")


# 4 - Save transformed data -----------------------------------------------


# Save data
saveRDS(f250.stack, "./data_clean/forestCover_sQ.RDS")


# 5 - Metadata ------------------------------------------------------------


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