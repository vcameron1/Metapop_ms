####
# title: Conceptual figures of the effect of habitat - e/c interation on persistence
# author: Victor Cameron
# date: 12/09/2022
####

# # Pannel 1
# ec_curve <- function(x) 0.5 * x + 0.08
# H_curve <- function(x) 0.75 - (0.5 * x)
# persistence_plot(ec_curve, H_curve, plot_name = "decrease_occ_plot")

# # Pannel 2
# ec_curve <- function(x) 0.8 * x + 0.1
# H_curve <- function(x) 0.8 * x + 0.3
# persistence_plot(ec_curve, H_curve, plot_name = "stable_occ_plot")

# # Pannel 3
# ec_curve <- function(x) 0.5 * x + 0.08
# H_curve <- function(x) 0.95 * x + 0.25
# persistence_plot(ec_curve, H_curve, plot_name = "increase_occ_plot")




# Plot function
persistence_plot <- function(ec_curve, H_curve, plot_name){
    # ec_curve: function giving the slope of the e/c curve
    # H_curve: function giving the slope of the habitat curve
    # plot_name: name of the plot to be saved

    # Save plot in file
    path <- paste0("./manuscript/img/", plot_name, ".png")
    png(path, width = 150, height = 150, units = "mm", res = 700, bg = "transparent")

    # Set graphic parameters
    par(pty = "s", par(pty = "s", mar = c(3, 4.6, 1, 0)), bg = NA)
    lwd <- 8
    cex_lab <- 2
    e1 = 0.3
    e2 = 0.6

    # e/c curve
    curve(ec_curve, 0, 0.9, 100,
        ylim = c(0, 0.9), xlim = c(0, 0.9),
        lwd = lwd, yaxt = "n", xaxt = "n",
        bty = "o", yaxs = "i", xaxs = "i",
        cex.lab = 2, cex.axis = 1.5,
        ylab = "",
        xlab = "",
        col = "darkorange"
    )

    # Axis titles
    title(
        ylab = "Components of\ndistribution dynamics",
        xlab = "Environment (E)",
        cex.lab = cex_lab, line = 1
    )

    # Resource (habitat) availability curve
    curve(H_curve, 0, 0.9, 100, add = T, lwd = lwd, col = "darkgreen")

    # Lines showing difference between H and e/c
    abline(v = e1, lwd = lwd/2, col = "grey70", lty = 2)
    abline(v = e2, lwd = lwd/2, col = "grey70", lty = 2)

    # Arrow showing difference between H and e/c
    arrows(e1, ec_curve(e1) + 0.01, e1, H_curve(e1) - 0.01, code = 3, col = "grey70", lwd = lwd/2)
    arrows(e2, ec_curve(e2) + 0.01, e2, H_curve(e2) - 0.01, code = 3, col = "grey70", lwd = lwd/2)

    # Text
    text(0.08, H_curve(0.1) + 0.08, expression("H(E"^"*" * ")"), col = "darkgreen", cex = cex_lab)
    text(0.07, ec_curve(0.1) + 0.05, "e/c", col = "darkorange", cex = cex_lab + 0.5)
    text(e1 + 0.05, 0.07, expression("E"[0]^"*"), cex = cex_lab, col = "grey70")
    text(e2 + 0.05, 0.07, expression("E"[1]^"*"), cex = cex_lab, col = "grey70")

    # Box to frame the plot
    box(lwd = lwd)

    # Close file
    dev.off()
}
