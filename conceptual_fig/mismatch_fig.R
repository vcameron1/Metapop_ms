#### 
# title: Spatial mismatch conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

# Save plot in file
png('../manuscript/img/concept_mismatch.png', width = 150, height = 150, units='mm', res = 700)

# Set graphic parameters
par(pty = "s",par(pty = "s",  mar=c(4.5,4.5,1,0)))
lwd <- 4

# e/c curve
curve((0.8 * x - 0.1), 0, 0.9, 100, ylim = c(0, 0.9), xlim = c(0, 0.9),
      lwd = lwd, yaxt = "n", xaxt = "n",
      bty = "o", yaxs="i", xaxs="i",
      cex.lab=2, cex.axis=1.5,
      ylab='', xlab='',
      col = 'darkorange')

# Resource (habitat) availability curve
curve(0.8-(0.9*x), 0, 0.9, 100,add=T, lwd=lwd, col='darkgreen')
text(0.02, 0.85, 'h', col='darkgreen', cex=1.5)
text(0.85, 0.8, 'e/c', col='darkorange', cex=1.5)

# Distribution polygon
mycol1 <- rgb(77, 77, 77, max = 255, alpha = 60)
polygon(x=c(0,0.535,0.535,0), y=c(0,0, 1, 1), col=mycol1, border=F)

# e/c (consumer) ratio shift
curve(0.8*x+0.2, 0,0.9,100,add=T, lwd=lwd, col='darkorange', lty=2)

# New distribution polygon
mycol2 <- rgb(77, 77, 77, max = 255, alpha = 80)
polygon(x=c(0,0.35,0.35,0), y=c(0,0, 1, 1), col=mycol2, border=F)

# Climatic conditions shift
arrows(0.535,0.32,0.15,0.32, lwd=4)

# Box to frame the plot
box(lwd=lwd) 

# Close file
dev.off()
