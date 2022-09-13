####
# title: Introductory figure of the effect of habitat - e/c interation on persistence
# author: Victor Cameron
# date: 12/09/2022
####

# Plot
intro_persistence_plot()

# Plot function
intro_persistence_plot <- function() {

    # Save plot in file
    path <- paste0("./manuscript/img/intro_persistence.png")
    png(path, width = 150, height = 150, units = "mm", res = 700)

    # Set graphic parameters
    par(pty = "s", par(pty = "s", mar = c(3, 4.6, 1, 0)), bg = NA)
    lwd <- 8
    cex_lab <- 2
    e1 = 0.3
    e2 = 0.6

    # Initiate plot
    plot(1, , type="n", ylim = c(0, 0.9), xlim = c(0, 0.9),
        lwd = lwd, yaxt = "n", xaxt = "n",
        bty = "o", yaxs = "i", xaxs = "i",
        cex.lab = 2, cex.axis = 1.5,
        ylab = "",
        xlab = "")

    # Axis titles
    title(
        ylab = "Components of\ndistribution dynamics",
        xlab = "Environment (E)",
        cex.lab = cex_lab, line = 1
    )

    # # Distribution polygon
    # mycol1 <- rgb(77, 77, 77, max = 255, alpha = 60)
    # polygon(x=c(0,0.75,0.75,0), y=c(0,0, 1, 1), col=mycol1, border=F)

    # # New distribution polygon
    # mycol2 <- rgb(77, 77, 77, max = 255, alpha = 80)
    # polygon(x=c(0,0.38,0.38,0), y=c(0,0, 1, 1), col=mycol1, border=F)

    # e/c curve
    curve(0.8 * x + 0.1, 0, 0.9, 100,
        ylim = c(0, 0.9), xlim = c(0, 0.9),
        lwd = lwd,
        col = "darkorange",
        add = TRUE
    )

    # Resource (habitat) availability curve
    abline(h = 0.7, lwd = lwd, col = "darkgreen")
    # abline(h = 0.4, lwd = lwd, col = "darkgreen")

    # Axis titles
    title(
        ylab = "Components of\ndistribution dynamics",
        xlab = "Environment (E)",
        cex.lab = cex_lab, line = 1
    )

    # Lines showing difference between H and e/c
    abline(v = 0.3, lwd = lwd/2, col = "grey70", lty = 2)
    abline(v = 0.5, lwd = lwd/2, col = "grey70", lty = 2)

    # Arrows
    arrows(0.5, 0.51, 0.5, 0.69, code = 3, lwd = lwd/2, col = "grey70")
    arrows(0.3, 0.35, 0.3, 0.69, code = 3, lwd = lwd/2, col = "grey70")

    # Text
    text(0.08, 0.75, expression("H=1"), col = "darkgreen", cex = cex_lab)
    # text(0.1, 0.45, expression("H=0.5"), col = "darkgreen", cex = cex_lab)
    text(0.07, 0.25, "e/c", col = "darkorange", cex = cex_lab + 0.5)

    text(0.35, 0.07, expression("E"[0]^"*"), cex = cex_lab, col = "grey70")
    text(0.55, 0.07, expression("E"[1]^"*"), cex = cex_lab, col = "grey70")

    text(0.52, 0.6, expression("S"^"*"), cex = cex_lab * 0.8, adj = 0, col = "grey70")

    # Box to frame the plot
    box(lwd = lwd)

    # Close file
    dev.off()
}
