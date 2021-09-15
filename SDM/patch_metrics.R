# taille des patchs et distance

# Params
RL_cutoff <- log(0.05)

patch.metrics <- function(raster, RL_cutoff = 0.05){

    #### Compute total habitat size ####
    raster[raster < RL_cutoff] <- NA
    area <- raster::area(raster, na.rm=TRUE) # in km2
    area <- area[!is.na(area)]
    sumArea <- sum(area, na.rm = TRUE)

    # Identify groups of cells that are connected
    clump <- raster::clump(raster >= RL_cutoff)


    #### Compute patch area (m2) ####
    values <- unique(values(clump))
    values <- values[!is.na(values)]
    patchArea <- data.frame(patch = values, area = 0)
    for(patch in patchArea$patch){
        # # Compute clump area 
        clumpX <- clump
        clumpX[clumpX != patch] <- NA
        clumpArea <- raster::area(clumpX, na.rm = TRUE)
        clumpArea <- clumpArea[!is.na(clumpArea)]
        clumpArea <- sum(clumpArea, na.rm = TRUE)
            
        # # Save in df
        patchArea[which(patchArea$patch == patch), 'area'] <- clumpArea
    }


    #### Number of patches ####
    n = length(patchArea$patch)


    #### Inter-patch distance ####
    clumpPoly <- raster::rasterToPolygons(clump, dissolve = TRUE)
    d_ij <- rgeos::gDistance(clumpPoly, byid = TRUE)


    #### Return ####
    return(
        list(
        totalArea = sumArea,
        n = n,
        patchArea = patchArea,
        d_ij = d_ij,
        )
    )
}