###############
# Script to compute landscape metrics
# Victor Cameron
# September 2021
##############

# This function returns a list of lists per time step. Each time step list contains the total area occupied by the species (sumArea), the total number of occupied patch (n), a data frame containing the area for each patch (patchArea), a matrix of the distance between each patch, and the metapop capacity of the landscape.

patch.metrics <- function(raster, RL_cutoff = 0.05){

    # 
    RL_cutoff = log(RL_cutoff)

    # Check if any values excced RL_cutoff
    if(raster::maxValue(raster) < RL_cutoff){
        sumArea = 0
        n = 0
        patchArea = 0
        d_ij = NA
        capacity = NA
    }else{
        #### Compute total habitat size ####
        raster[raster < RL_cutoff] <- NA
        area <- raster::area(raster, na.rm=TRUE) # in km2
        area <- area[!is.na(area)]
        sumArea <- sum(area, na.rm = TRUE)

        # Identify groups of cells that are connected
        clump <- raster::clump(raster >= RL_cutoff)


        #### Compute patch area (m2) ####
        values <- unique(raster::values(clump))
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

        #### Metapop capacity ####

        # Compute landscape matrix
        ##exp(-a*d)*A1*A2 as in Hanski 2000

        land <- matrix(rep(0, length(d_ij)), nrow=nrow(d_ij))
        a <- 1/2
        for(i in patchArea$patch){
            for(j in patchArea$patch){
            if(i == j) next
            land[i,j] <- exp(-a*d_ij[i,j]) * patchArea[i,'area'] * patchArea[j,'area']
            }
        }

        # Metapop capacity
        eigen = eigen(land)$values[1]

    }

    #### Return ####
    return(
        list(
        totalArea = sumArea,
        n = n,
        patchArea = patchArea,
        d_ij = d_ij,
        capacity = eigen)
    )
}
