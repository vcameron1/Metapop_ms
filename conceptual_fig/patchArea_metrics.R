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
