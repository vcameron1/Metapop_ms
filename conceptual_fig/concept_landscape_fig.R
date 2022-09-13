#### 
# title: Conceptual figure of the effect of spatial structure on persistence
# author: Victor Cameron
# date: 08/09/2022
####

concept_land_fig <- function() {
    # Save plot in file
    png('./manuscript/img/metapop_spatial_structure.png', width = 150, height = 150, units='mm', res = 700)

    # Set graphic parameters
    par(pty = "s", par(pty = "s", mar = c(1, 1, 1, 1)), bg = NA)
    lwd <- 5

    # Landscape params
    ## Contraction
    r <- -0.1
    ## Patches sizes
    patches <- list(
        patch_1 = list(
            radius = 0.2,
            center_x = -0.5,
            center_y = 0.7),
        patch_2 = list(
            radius = 0.25,
            center_x = 0.5,
            center_y = 0.5),
        patch_3 = list(
            radius = 0.1,
            center_x = -0.1,
            center_y = 0.2),
        patch_4 = list(
            radius = 0.2,
            center_x = 0.5,
            center_y = -0.2),
        patch_5 = list(
            radius = 0.15,
            center_x = -0.2,
            center_y = -0.75)
    )

    # initialize a plot
    plot(x = c(-1, 1),
        y = c(-1, 1),
        type = "n",
        ylab = "",
        xlab = "",
        yaxt = "n",
        xaxt = "n",
        bty = "o",
        yaxs = "i",
        xaxs = "i")

    # Draw patches
    for (patch in patches) {
        with(patch, {
            ## Initial patch
            circle(radius, center_x, center_y, lwd = lwd)
            ## Initial patch
            circle(radius + r, center_x, center_y, lwd = lwd/2, lty = 3)
        })
    }

    # Draw lines between patches
    ## Line patch 1-2
    lines(
        x = c(
            with(patches[["patch_1"]], center_x + radius),
            with(patches[["patch_2"]], center_x - radius)),
        y = c(
            with(patches[["patch_1"]], center_y),
            with(patches[["patch_2"]], center_y)),
        lwd = lwd)
    ## Line patch 1-3
    lines(
        x = c(
            with(patches[["patch_1"]], center_x),
            with(patches[["patch_3"]], center_x)),
        y = c(
            with(patches[["patch_1"]], center_y - radius),
            with(patches[["patch_3"]], center_y + radius)),
        lwd = lwd, col = "grey")
    ## Line patch 2-3
    lines(
        x = c(
            with(patches[["patch_2"]], center_x - radius),
            with(patches[["patch_3"]], center_x)),
        y = c(
            with(patches[["patch_2"]], center_y),
            with(patches[["patch_3"]], center_y + radius)),
        lwd = lwd, col = "grey")
    ## Line patch 2-4
    lines(
        x = c(
            with(patches[["patch_2"]], center_x),
            with(patches[["patch_4"]], center_x)),
        y = c(
            with(patches[["patch_2"]], center_y - radius),
            with(patches[["patch_4"]], center_y + radius)),
        lwd = lwd)
    ## Line patch 3-4
    lines(
        x = c(
            with(patches[["patch_3"]], center_x),
            with(patches[["patch_4"]], center_x - radius)),
        y = c(
            with(patches[["patch_3"]], center_y - radius),
            with(patches[["patch_4"]], center_y)),
        lwd = lwd, col = "grey")
    ## Line patch 4-5
    lines(
        x = c(
            with(patches[["patch_4"]], center_x),
            with(patches[["patch_5"]], center_x + radius)),
        y = c(
            with(patches[["patch_4"]], center_y - radius),
            with(patches[["patch_5"]], center_y)),
        lwd = lwd)

    # Frame the figure
    box(lwd = lwd)

    # Close file
    dev.off()
}


# Function to draw circles
circle <- function(radius, center_x, center_y, ...) {
    theta = seq(0, 2 * pi, length = 200) # angles for drawing points around the circle
    lines(x = radius * cos(theta) + center_x,
    y = radius * sin(theta) + center_y, ...)
}



# source('./conceptual_fig/concept_landscape_fig.R'); concept_land_fig()

