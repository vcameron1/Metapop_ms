###############
# Script to compute landscape metrics
# Victor Cameron
# September 2021
##############

# This function returns a list of lists per time step. Each time step list contains the total area occupied by the species (sumArea), the total number of occupied patch (n), a data frame containing the area for each patch (patchArea), a matrix of the distance between each patch, and the metapop capacity of the landscape.

patch.metrics <- function(projRaster, RL_cutoff = 0.05, a = 1/2, x = 1){

    # 
    RL_cutoff = log(RL_cutoff) ## Log RL because projections were log

    # Results containers
    n <- c()                  ## Number of patches
    totalArea <- c()          ## Total area
    capacity <- setNames(data.frame(matrix(ncol = 3, nrow = 0)), c("capacity", "alpha", "scenario")) ## Metapopulation capacity
    patchArea <- setNames(data.frame(matrix(ncol = 3, nrow = 0)), c("patch", "area", "scenario")) ## individual patch areas
    d_ij <- list()            ## inter-patch distance matrices

    # Loop accros projections to compute metrics
    for(i in seq_along(names(projRaster))){
        raster = projRaster[[i]]
        cat("processing ", (names(raster)), "\n")
        # Check if any values excced RL_cutoff
        if(raster::maxValue(raster) < RL_cutoff){
            n[i] = 0
            totalArea[i] = 0
            capacity <- rbind(capacity, data.frame(capacity = rep(0,length(a)), alpha = a, scenario = names(raster)))
            patchArea <- rbind(patchArea, data.frame(patch = NA, area = 0, scenario = names(raster)))
            patchArea <- rbind(patchArea, data.frame(patch = NA, area = 0, scenario = names(raster))) ## Double row so it doesn't get dropped when plotting results
            d_ij[[i]] = matrix(0,2,2)
        }else{
            #### Compute total habitat size ####
            raster[raster < RL_cutoff] <- NA
            area <- raster[!is.na((raster))]
            totalArea[i] <- (length(area) * raster::res(raster)[1] * raster::res(raster)[2]) / 1000^2 # in km2
            
            # Identify groups of cells that are connected
            clump <- raster::clump(raster >= RL_cutoff)

            #### Compute patch area (km2) ####
            values <- unique(raster::values(clump))
            values <- values[!is.na(values)]
            for(patch in seq_along(values)){
                # # Compute clump area 
                clumpX <- clump
                clumpX[clumpX != patch] <- NA
                clumpX <- clumpX[!is.na(clumpX)]
                clumpArea <- (length(clumpX) * raster::res(raster)[1] * raster::res(raster)[2]) / 1000^2 # in km2
                    
                # # Save in df
                patchArea <- rbind(patchArea, data.frame(patch = patch, area = clumpArea, scenario = names(raster)))
            }
            #patchArea <- patchArea[!is.na(patchArea$area),]
            #patchArea$area <- as.numeric(patchArea$area)

            #### Number of patches ####
            n[i] = length(patchArea[patchArea$scenario==names(raster), "patch"])


            #### Inter-patch distance ####
            clumpPoly <- raster::rasterToPolygons(clump, dissolve = TRUE)
            d_ij[[i]] <- rgeos::gDistance(clumpPoly, byid = TRUE) / 1000 # in km


            #### Metapop capacity ####
            # Compute landscape matrix
            ##exp(-a*d)*A1*A2 as in Hanski 2000

            land <- matrix(rep(0, length(d_ij[[i]])), nrow=nrow(d_ij[[i]]))
            for(alpha in a){
                for(patch_i in seq_along(values)){
                    for(patch_j in seq_along(values)){
                    if(patch_i == patch_j) next
                    land[patch_i,patch_j] <- exp(-alpha*d_ij[[i]][patch_i,patch_j]) * 
                                    patchArea[patchArea$scenario==names(raster) & patchArea$patch==patch_i,'area']^x * 
                                    patchArea[patchArea$scenario==names(raster) & patchArea$patch==patch_j,'area']
                    }
                }
                # Metapop capacity
                capacity <- rbind(capacity, data.frame(capacity = eigen(land)$values[1], alpha = alpha, scenario = names(raster)))
                #capacity <- capacity[!is.na(capacity$capacity),]
                #capacity$capacity <- as.numeric(capacity$capacity)
            }
        }
    }

    # Rename result containers
    names(n) = names(totalArea) = names(d_ij) <- names(projRaster)

    #### Return ####
    return(
        list(
            n = n,
            totalArea = totalArea,
            capacity = capacity,
            patchArea = patchArea,
            d_ij = d_ij))
}


# This function computes the capacity of a landscape
## metrics <- readRDS("./SDM/results/metrics_ET.RDS")
get.capacity <- function(metrics, alpha = 1/2, cc){
    
    eigen <- data.frame(eigen = rep(0,length(metrics)), temp = cc)
    
    # Loop through time steps
    for(i in 1:length(metrics)){

        if(metrics[[i]]$n == 0){
            eigen[i,] = c(0, cc[i])
            next
        }

        #### Extract patch area ####
        area <- metrics[[i]]$patchArea

        #### Extract inter-patch distance ####
        dist <- metrics[[i]]$d_ij

        #### Metapop capacity ####
        ##exp(-a*d)*A1*A2 as in Hanski 2000
        land <- matrix(rep(0, length(dist)), nrow=nrow(dist))
        for(col in area$patch){
            for(row in area$patch){
                if(col == row) next
                land[row,col] <- exp(-alpha*dist[row,col]) * area[col,'area'] * area[row,'area']
            }
        }

        # Metapop capacity
        eigen[i,] = c(eigen(land)$values[1], cc[i])

    }
    return(eigen)
}
