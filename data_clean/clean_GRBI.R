#############################################################
## Clean SOS-POP GRBI dataset
## Generate a raster* of presences and pseudo absences
## Return spatial points that actually are the raster cells centroids
## Victor Cameron 
## August 2021
#############################################################

# 0 - Set directory -------------------------------------------------------

setwd("~/Documents/Git/Metapop_ms")


# 1 - Import data ---------------------------------------------------------


GRBI <- readxl::read_excel("./data_raw/RAPPORT QO_SOS-POP SCF_GRBI.xlsx", sheet = 2)


# 2 - Explore GRBI data ---------------------------------------------------


# Available variables/data
#colnames(GRBI)

# Spatial distribution of points
#plot(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION', GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')
#NA %in% unique(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')
#NA %in% unique(GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')

# Spatial distribution of points by site
#sunflowerplot(GRBI$LONGITUDE, GRBI$LATITUDE)

# Temporal distribution of occurences
#hist(GRBI$ANNEE) # Year 1000?
#sort(unique(GRBI$ANNEE)) 
#GRBI[GRBI$ANNEE < 2000, c("NOM SITE", "LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION", "LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION", "ANNEE" )]
#hist(GRBI$ANNEE[GRBI$ANNEE > 1990])

# Distribution of precisions
#table(GRBI$PRÉCISION)

# Distribution of classifications
#table(GRBI$CLASSIFICATION)

# Distribution of usage
#table(GRBI$USAGE)

# Distribution of types of occurences
#table(GRBI$O_CODEATLA)


# 2 - Clean GRBI data -----------------------------------------------------


# Select occurences that have coordinates data
GRBI <- GRBI[!is.na(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION') & !is.na(GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION'),]

# Select occurences with PRÉCISION == "S" 
# which corresponds to coordinates precise to the second
GRBI <- GRBI[GRBI$PRÉCISION == "S",]
  
# Remove recordings of absences
GRBI <- GRBI[GRBI$O_CODEATLA != "0",]
  
# Select presence in habitat 
#GRBI <- GRBI[GRBI$O_CODEATLA == c("H"),]

# Select occurences with classification "R" 
# occurences that are certain
GRBI <- GRBI[GRBI$CLASSIFICATION == "R",]

# Select nidification usage
GRBI <- GRBI[GRBI$USAGE == "Nidification",]


# 3 - Crop GRBI data to region of interest --------------------------------


# Load reference raster
template <- readRDS("./data_clean/templateRaster_sQ.RDS")

# Crop GRBI presence data
GRBI <- GRBI[GRBI$LONGITUDE >= raster::xmin(template) & 
               GRBI$LONGITUDE <= raster::xmax(template) & 
               GRBI$LATITUDE >= raster::ymin(template) & 
               GRBI$LATITUDE <= raster::ymax(template),]


# 4 - Rasterize GRBI occurences -------------------------------------------


# Load reference spatialPolygons
spacePoly <- readRDS("./SDM/spacePoly.RDS")

# Rasterize GRBI occurences as presences/absences
GRBI_points <- sp::SpatialPoints(cbind(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION', GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION'), proj4string = spacePoly@proj4string)
GRBI <- raster::rasterize(GRBI_points, template, fun='count')


# 5 - GRBI raster back to spatialPoints -----------------------------------


# Back to spatialPoints
GRBI[GRBI > 0] <- 1
GRBI_points <- raster::rasterToPoints(GRBI) # Keep cell centroids
GRBI_points <- sp::SpatialPoints(GRBI_points,
                                  proj4string = spacePoly@proj4string)


# 6 - Save rasterized GRBI occurences -----------------------------------


saveRDS(GRBI_points, "./data_clean/GRBI_rasterPoints_sQ.RDS")
