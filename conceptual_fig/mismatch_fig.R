#### 
# title: Spatial mismatch conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

mismatch_plot <- function(){
   # Save plot in file
   png('./manuscript/img/concept_mismatch.png', width = 150, height = 150, units='mm', res = 700)
   
   # Set graphic parameters
   par(pty = "s",par(pty = "s",  mar=c(3,3,1,0)))
   lwd <- 4
   
   # e/c curve
   curve((0.8 * x + 0.1), 0, 0.9, 100, ylim = c(0, 0.9), xlim = c(0, 0.9),
         lwd = lwd, yaxt = "n", xaxt = "n",
         bty = "o", yaxs="i", xaxs="i",
         cex.lab=2, cex.axis=1.5,
         ylab='', 
         xlab='',
         col = 'darkorange')
   
   # Axis titles
   title(ylab = "Components of distribution dynamics",
         xlab='Environment (E)',
         cex.lab = 1.5, line = 1)
   
   # Distribution polygon
   mycol1 <- rgb(77, 77, 77, max = 255, alpha = 60)
   polygon(x=c(0,0.31,0.31,0), y=c(0,0, 1, 1), col=mycol1, border=F)
   
   # New distribution polygon
   mycol2 <- rgb(77, 77, 77, max = 255, alpha = 80)
   polygon(x=c(0,0.5,0.5,0), y=c(0,0, 1, 1), col=mycol1, border=F)
   
   # e/c curve
   curve((0.8 * x + 0.1), 0, 0.9, 100, add=T, lwd = lwd, col = 'darkorange')
   
   # Resource (habitat) availability curve
   curve(0.6-(0.8*x), 0, 0.9, 100,add=T, lwd=lwd, col='darkgreen')
   
   # Resource (habitat) availability shift
   curve(0.9-(0.8*x), 0, 0.9, 100,add=T, lwd=lwd, col='darkgreen', lty=2)
   
   # Climatic conditions shift
   arrows(0.313,0.35,0.69,0.35, lwd=4)
   
   # Text
   text(0.07, 0.6, 'R', col='darkgreen', cex=1.5)
   text(0.07, 0.23, 'e/c', col='darkorange', cex=1.5)
   
   # Box to frame the plot
   box(lwd=lwd) 
   
   # Close file
   dev.off()
}
