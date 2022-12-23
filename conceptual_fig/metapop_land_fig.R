#### 
# title: Metapop landscape figure
# author: Victor Cameron
# date: 23/12/2022
####

metapop_land_fig <- function(patches, r, initial_patches = TRUE, plot_name = './manuscript/img/metapop_spatial_structure.png') {
    # Save plot in file
    png(plot_name, width = 150, height = 150, units='mm', res = 700)

    # Set graphic parameters
    par(pty = "s", par(pty = "s", mar = c(1, 1, 1, 1)), bg = NA)
    lwd <- 5

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
    raster::plot(patches, col = rgb(77, 77, 77, max = 255, alpha = 60), lwd = lwd)
    # for (patch in patches) {
    #     with(patch, {
    #         ## Initial patch
    #         if (initial_patches) circle(radius, center_x, center_y, lwd = lwd)
    #         ## Final patch
    #         if (!initial_patches) {
    #             if (radius + r > 0) circle(radius + r, center_x, center_y, lwd = lwd, lty = 1)
    #         }
    #     })
    # }

    # # Draw lines between patches
    # ## Line patch 1-2
    # lines(
    #     x = c(
    #         with(patches[["patch_1"]], center_x + radius),
    #         with(patches[["patch_2"]], center_x - radius)),
    #     y = c(
    #         with(patches[["patch_1"]], center_y),
    #         with(patches[["patch_2"]], center_y)),
    #     lwd = lwd)
    # ## Line patch 1-3
    # lines(
    #     x = c(
    #         with(patches[["patch_1"]], center_x),
    #         with(patches[["patch_3"]], center_x)),
    #     y = c(
    #         with(patches[["patch_1"]], center_y - radius),
    #         with(patches[["patch_3"]], center_y + radius)),
    #     lwd = lwd, col = "grey")
    # ## Line patch 2-3
    # lines(
    #     x = c(
    #         with(patches[["patch_2"]], center_x - radius),
    #         with(patches[["patch_3"]], center_x)),
    #     y = c(
    #         with(patches[["patch_2"]], center_y),
    #         with(patches[["patch_3"]], center_y + radius)),
    #     lwd = lwd, col = "grey")
    # ## Line patch 2-4
    # lines(
    #     x = c(
    #         with(patches[["patch_2"]], center_x),
    #         with(patches[["patch_4"]], center_x)),
    #     y = c(
    #         with(patches[["patch_2"]], center_y - radius),
    #         with(patches[["patch_4"]], center_y + radius)),
    #     lwd = lwd)
    # ## Line patch 3-4
    # lines(
    #     x = c(
    #         with(patches[["patch_3"]], center_x),
    #         with(patches[["patch_4"]], center_x - radius)),
    #     y = c(
    #         with(patches[["patch_3"]], center_y - radius),
    #         with(patches[["patch_4"]], center_y)),
    #     lwd = lwd, col = "grey")
    # ## Line patch 4-5
    # lines(
    #     x = c(
    #         with(patches[["patch_4"]], center_x),
    #         with(patches[["patch_5"]], center_x + radius)),
    #     y = c(
    #         with(patches[["patch_4"]], center_y - radius),
    #         with(patches[["patch_5"]], center_y)),
    #     lwd = lwd)

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
