#### 
# title: Spatial mismatch conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

mismatch_plot <- function() {
      # Save plot in file
      png("./manuscript/img/concept_mismatch.png", width = 150, height = 150, units = "mm", res = 700)

      # Set graphic parameters
      par(pty = "s", par(pty = "s", mar = c(3, 4.6, 1, 0)), bg = NA)
      lwd <- 8
      cex_lab <- 2

      # Initiate plot
      plot(1, ,
            type = "n", ylim = c(0, 0.9), xlim = c(0, 0.9),
            lwd = lwd, yaxt = "n", xaxt = "n",
            bty = "o", yaxs = "i", xaxs = "i",
            cex.lab = 2, cex.axis = 1.5,
            ylab = "",
            xlab = ""
      )

      # Distribution polygon
      mycol1 <- rgb(77, 77, 77, max = 255, alpha = 60)
      polygon(x = c(0, 0.32, 0.32, 0), y = c(0, 0, 1, 1), col = mycol1, border = F)

      # New distribution polygon
      mycol2 <- rgb(77, 77, 77, max = 255, alpha = 80)
      polygon(x = c(0, 0.485, 0.485, 0), y = c(0, 0, 1, 1), col = mycol1, border = F)

      # e/c curve
      curve((0.6 * x + 0.1), 0, 0.9, 100,
            ylim = c(0, 0.9), xlim = c(0, 0.9),
            lwd = lwd, col = "darkorange", add = TRUE
      )

      # Resource (habitat) availability curve
      curve(0.6 - (0.95 * x), 0, 0.9, 100, add = T, lwd = lwd, col = "darkgreen")

      # Resource (habitat) availability shift
      curve(0.85 - (0.95 * x), 0, 0.9, 100, add = T, lwd = lwd, col = "darkgreen", lty = 5)

      # Axis titles
      title(
            ylab = "Components of\ndistribution dynamics",
            xlab = "Environment (E)",
            cex.lab = cex_lab, line = 1
      )

      # Climatic conditions shift
      arrows(0.63, 0.02, 0.85, 0.02, lwd = lwd * 0.75)

      # Text
      text(0.08, 0.63, expression("H(E"^"*" * ")"), col = "darkgreen", cex = cex_lab)
      text(0.07, 0.23, "e/c", col = "darkorange", cex = cex_lab + 0.5)

      # Box to frame the plot
      box(lwd = lwd)

      # Close file
      dev.off()
}
