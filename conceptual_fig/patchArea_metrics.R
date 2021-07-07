###############
# Script to compute landscape metrics
# Victor Cameron
# 7/07/21
##############

patchArea_metrics <- function(elevation){
  
  #### Compute habitat size ####
  
  # # 700m+
  habitat700 <- elevation
  habitat700[habitat700<700] <- NA
  area700 <- raster::area(habitat700, na.rm=TRUE)
  area700 <- area700[!is.na(area700)]
  area700 <- sum(area700, na.rm = TRUE)
  
  # # 800m+
  habitat800 <- elevation
  habitat800[habitat800<800] <- NA
  area800 <- raster::area(habitat800, na.rm=TRUE)
  area800 <- area800[!is.na(area800)]
  area800 <- sum(area800, na.rm = TRUE)
  
  # Identify groups of cells that are connected
  clump700 <- raster::clump(elevation>=700)
  clump800 <- raster::clump(elevation>=800)
  
  
  #### Compute patch area (m2) ####
  
  # # 700m
  values <- unique(values(clump700))
  values <- values[!is.na(values)]
  patchArea700 <- data.frame(patch = values, area = 0)
  for(patch in patchArea700$patch){
    # # # Compute clump area 
    clump <- clump700
    clump[clump!=patch] <- NA
    clumpArea <- raster::area(clump, na.rm=T)
    clumpArea <- clumpArea[!is.na(clumpArea)]
    clumpArea <- sum(clumpArea, na.rm=T)
        
    # # # Save in df
    patchArea700[which(patchArea700$patch==patch), 'area'] <- clumpArea
  }
    
  # # 800m
  values <- unique(values(clump800))
  values <- values[!is.na(values)]
  patchArea800 <- data.frame(patch = values, area = 0)
  for(patch in patchArea800$patch){
  # # # Compute clump area 
    clump <- clump800
    clump[clump!=patch] <- NA
    clumpArea <- raster::area(clump, na.rm=T)
    clumpArea <- clumpArea[!is.na(clumpArea)]
    clumpArea <- sum(clumpArea, na.rm=T)
      
    # # # Save in df
    patchArea800[which(patchArea800$patch==patch), 'area'] <- clumpArea
  }

  
  #### Number of patches ####
  n700 = length(patchArea700$patch)
  n800 = length(patchArea800$patch)
  
  
  #### Metapop capacity ####
  
  # Compute inter-patch distance
  clump700Poly <- raster::rasterToPolygons(clump700, dissolve=T)
  d700 <- rgeos::gDistance(clump700Poly, byid=T)
  
  clump800Poly <- raster::rasterToPolygons(clump800, dissolve=T)
  d800 <- rgeos::gDistance(clump800Poly, byid=T)
  
  # Compute landscape matrix
  ##exp(-a*d)*A1*A2 as in Hanski 2000
  
  # # 700m
  land700 <- matrix(rep(0, length(d700)), nrow=nrow(d700))
  a <- 1/20
  for(i in patchArea700$patch){
    for(j in patchArea700$patch){
      if(i == j) next
      land700[i,j] <- exp(-a*d700[i,j])*
        (patchArea700[i,'area']/max(patchArea700[,'area']))* # Normalize patch area
        (patchArea700[j,'area']/max(patchArea700[,'area']))
    }
  }
  
  # # 800m
  land800 <- matrix(rep(0, length(d800)), nrow=nrow(d800))
  for(i in patchArea800$patch){
    for(j in patchArea800$patch){
      if(i == j) next
      land800[i,j] <- exp(-a*d800[i,j])*
        (patchArea800[i,'area']/max(patchArea800[,'area']))*
        (patchArea800[j,'area']/max(patchArea800[,'area']))
    }
  }
  
  # Metapop capacity
  eigen700= eigen(land700)$values[1]
  eigen800 = eigen(land800)$values[1]
  
  print(paste0("Metapop capacity declines by ", round((1-(eigen(land800)$values[1]/eigen(land700)$values[1]))*100,1), "% between 700 and 800m"))
  
  #### Return ####
  return(
    list(
      totalArea700 = area700,
      totalArea800 = area800,
      n700 = n700,
      n800 = n800,
      patchArea700 = patchArea700,
      patchArea800 = patchArea800,
      d700 = d700,
      d800 = d800,
      land700 = land700,
      land800 = land800,
      eigen700 = eigen700,
      eigen800 = eigen700
    )
  )
}
