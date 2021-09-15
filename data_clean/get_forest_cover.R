#############################################################
## Download forest cover for the south of Quebec
## Victor Cameron 
## July 2021
#############################################################

#############################################################
## Data downloaded from: https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/DONNEES_FOR_ECO_SUD/Resultats_inventaire_et_carte_ecofor/
## "_NC" files were selected when available
## The downloaded data are polygons of forest cover at 250m
#############################################################


# 1 - Download data -------------------------------------------------------


# List feuillets to download
feuillets <- c("31G", "31J", "31O", "32B", "32G",
               "31H", "31I", "31P", "32A", "32H",
               "21E", "21M", "21L", "22D", "22E",
               "21K", "21N", "22C", "22F", 
               "21O", "22B", "22G",
               "22A", "22H",
               "32J", "32I", "22L", "22K", "22J", "22I")

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


all(feuillets %in% unique(f_250$feuillet))
# Save data
saveRDS(f_250, "./data_clean/f_250.RDS")


