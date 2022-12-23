###############
# Script to compute landscape metrics
# Victor Cameron
# 7/07/21
##############

patch_area_metrics <- function(patches, r) {

  #### Prep data ####
  spatial_polys1 <- patches[[1]]
  spatial_polys2 <- patches[[2]]

  #### Total area ####
  area1 <- rgeos::gArea(spatial_polys1, byid=T)
  tot_area1 <- sum(area1)
  area2 <- rgeos::gArea(spatial_polys2, byid=T)
  tot_area2 <- sum(area2)

  #### Number of patches ####
  n1 <- length(spatial_polys1)
  n2 <- length(spatial_polys2)


  #### Metapop capacity ####

  # Compute inter-patch distance
  d1 <- rgeos::gDistance(spatial_polys1, byid=T)
  d2 <- rgeos::gDistance(spatial_polys2, byid=T)

  # Compute landscape matrix
  ##exp(-a*d)*A1*A2 as in Hanski 2000

  ## d1
  land1 <- matrix(rep(0, length(d1)), nrow=nrow(d1))
  a <- 1/0.15 # units dispersal distance
  for(i in seq_along(area1)){
    for(j in seq_along(area1)){
      if(i == j) next
      land1[i,j] <- exp(-a*d1[i,j])*
        (area1[i]/max(area1))* # Normalize patch area
        (area1[j]/max(area1))
    }
  }

  ## d2
  land2 <- matrix(rep(0, length(d2)), nrow=nrow(d2))
  for(i in seq_along(area2)){
    for(j in seq_along(area2)){
      if(i == j) next
      land2[i,j] <- exp(-a*d2[i,j])*
        (area2[i]/max(area2))* # Normalize patch area
        (area2[j]/max(area2))
    }
  }

  # Metapop capacity
  eigen1 = eigen(land1)$values[1]
  eigen2 = eigen(land2)$values[1]

  print(paste0(
    "Metapop capacity declines by ", round((1-(eigen2/eigen1))*100,1), "% between both panels and ",
    "Habitat amount declines by ", round((1-(tot_area2/tot_area1))*100,1), "%"))

  #### Return ####
  return(
    list(
      totalArea1 = tot_area1,
      totalArea2 = tot_area2,
      n1 = n1,
      n2 = n2,
      patchArea1 = tot_area1,
      patchArea2 = tot_area2,
      d1 = d1,
      d2 = d2,
      land1 = land2,
      land2 = land2,
      eigen1 = eigen2,
      eigen2 = eigen2
    )
  )
}



###############
# Script to compute landscape metrics
# Victor Cameron
# 7/07/21
##############

patchArea_metrics_raster <- function(elevation){
  
  #### Compute habitat size ####
  
  # # 700m+
  habitat700 <- elevation
  area700 <- table(values(habitat700>=700))[2] * dim(habitat700)[1] * dim(habitat700)[2] # Area in m2
  
  # # 800m+
  habitat800 <- elevation
  area800 <- table(values(habitat800>=800))[2] * dim(habitat800)[1] * dim(habitat800)[2] # Area in m2
  
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
    clumpArea <- table(values(clump700==patch))["TRUE"] * dim(clump700)[1] * dim(clump700)[2] # Area in m2
        
    # # # Save in df
    patchArea700[which(patchArea700$patch==patch), 'area'] <- clumpArea
  }
    
  # # 800m
  values <- unique(values(clump800))
  values <- values[!is.na(values)]
  patchArea800 <- data.frame(patch = values, area = 0)
  for(patch in patchArea800$patch){
  # # # Compute clump area
  clumpArea <- table(values(clump800==patch))["TRUE"] * dim(clump800)[1] * dim(clump800)[2] # Area in m2

      
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
  a <- 1/200000 # 100km mean dispersal distance
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
  
  print(paste0(
    "Metapop capacity declines by ", round((1-(eigen(land800)$values[1]/eigen(land700)$values[1]))*100,1), "% between 700 and 800m and ",
    "Habitat amount declines by ", round((1-(area800/area700))*100,1), "%"))
  
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
