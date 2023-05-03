#### 
# title: Conceptual figure of the effect of spatial structure on persistence
# author: Victor Cameron
# date: 23/12/2022
####

# Landscape params
get_land <- function() {
    ## Contraction
    r <- -0.08

    ## Patches sizes and positions
    patches <- list(
        patch_1 = list(
            radius = 0.3,
            center_x = -0.35,
            center_y = 0.45),
        patch_2 = list(
            radius = 0.15,
            center_x = 0.25,
            center_y = 0.55),
        patch_3 = list(
            radius = 0.08,
            center_x = -0.75,
            center_y = 0.15),
        patch_4 = list(
            radius = 0.2,
            center_x = -0.6,
            center_y = -0.25),
        patch_5 = list(
            radius = 0.1,
            center_x = 0.65,
            center_y = 0.25),
        patch_6 = list(
            radius = 0.05,
            center_x = -0.05,
            center_y = -0.1),
        patch_7 = list(
            radius = 0.05,
            center_x = 0.25,
            center_y = -0.0),
        patch_8 = list(
            radius = 0.2,
            center_x = 0.45,
            center_y = -0.6),
        patch_9 = list(
            radius = 0.09,
            center_x = -0.35,
            center_y = -0.8)
    )

    # Tranform patches into polygons
    polys1 <- list()
    polys2 <- list()
    for (i in seq_along(patches)) {
      theta = seq(0, 2 * pi, length = 200) # angles for drawing points around the circle
      x = patches[[i]]$radius * cos(theta) + patches[[i]]$center_x
      y = patches[[i]]$radius * sin(theta) + patches[[i]]$center_y

      polys1[[i]] <- sp::Polygons(list(sp::Polygon(cbind(x,y))), ID = i)

      # Multipolygons contracted by r
      ## Only compute if patch still exists
      if (patches[[i]]$radius + r > 0) {
        x2 = (patches[[i]]$radius + r) * cos(theta) + patches[[i]]$center_x
        y2 = (patches[[i]]$radius + r) * sin(theta) + patches[[i]]$center_y

        polys2[[length(polys2) + 1]] <- sp::Polygons(list(sp::Polygon(cbind(x2,y2))), ID = i)
      }
    }

    # Transform to spatial polygons
    spatial_polys1 <- sp::SpatialPolygons(polys1)
    spatial_polys2 <- sp::SpatialPolygons(polys2)


    return(list(land1 = spatial_polys1,
        land2 = spatial_polys2,
        r = r))
}

# Plot conceptual figure
concept_land_fig <- function(patches, r) {
    # Dependencies
    source("./conceptual_fig/metapop_land_fig.R")
    source("./conceptual_fig/plot_image.R")

    # Generate plots
    ## Pannel 1
    metapop_land_fig(patches[[1]], r, initial_patches = TRUE, plot_name = './manuscript/img/metapop_spatial_structure_1.png')
    ## Pannel 2
    metapop_land_fig(patches[[2]], r, initial_patches = FALSE, plot_name = './manuscript/img/metapop_spatial_structure_2.png')

    # Plot parameters
    cex_lab <- 2

    # Save plot in file
    png('./manuscript/img/concept_metapop_structure.png', width = 310, height = 150, units='mm', res = 700, bg = "transparent")

    par(fig=c(0,0.5,0,1))
    plotimage(file = './manuscript/img/metapop_spatial_structure_1.png', size = 1, add = F, bg = "transparent")
    mtext("", adj=0, line=-1.5, cex=cex_lab)
    par(fig=c(0.5,1,0,1), new=TRUE)
    plotimage(file = './manuscript/img/metapop_spatial_structure_2.png', size = 1, add = T, bg = "transparent")
    mtext("", adj=0, line=-1.5, cex=cex_lab)

    # Close file
    dev.off()

    # Remove temporary plots
    file.remove('./manuscript/img/metapop_spatial_structure_1.png')
    file.remove('./manuscript/img/metapop_spatial_structure_2.png')
}

land <- get_land()
concept_land_fig(land[1:2], land$r)
