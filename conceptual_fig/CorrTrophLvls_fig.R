#### 
# title: Environmental correlation between trophic levels conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

# Dependencies
library(ggplot2)
source('2spMetapop_model.R')

# Parameters
lwd = 4

# Save plot in file
png('../manuscript/img/concept_CorrTrophLvls.png', width = 150, height = 150, units='mm', res = 700)

# Envrionmental gradient
x <- y <- seq(0, 1, by=0.025)

z <- matrix(0, nrow = length(x), ncol = length(y))

# Compute prevalences
i = 0
for(resource in x){
  i = i + 1
  j = 0
  for(consumer in y){
    j = j + 1
    occ1 <- consumerOcc(resOpt=resource, consOpt=consumer, E=0.5) 
    occ2 <- consumerOcc(resOpt=resource, consOpt=consumer, E=0.6)
    z[j, i] <- occ2 - occ1
  }
}

# Plot
par(pty = "s",par(pty = "s", mar=c(4.5,4.5,1,0)))
lwd <- 4

## Center range on 0
max_abs <- max(abs(z))
brk <- lattice::do.breaks(c(-max_abs, max_abs), length(c(z)))
## Plot
image(z, col=hcl.colors(length(z), "Red-Green"), breaks = brk,
      lwd=lwd, yaxs="i", xaxs="i",
      yaxt='n', xaxt='n',
      cex.lab=2, cex.axis=1.5,
      ylab='', xlab='')
abline(0, 1, lty=2)
box(lwd=lwd) 
## Color scale
par(mar=c(3,1,1,1))
image.scale(z, col=hcl.colors(length(z), "Red-Green"))
box()

# Close file
dev.off()







#### Function to add a scale to the image() function ####

# It is important to remember that for the scales to appear next to the plots, the layout must be correctly specified
#layout(matrix(c(1,2,3,0,4,0), nrow=2, ncol=3), widths=c(4,4,1), heights=c(4,1))
#layout.show(4)

image.scale <- function(z, zlim, col = heat.colors(12),
                        breaks, horiz=TRUE, ylim=NULL, xlim=NULL, ...){
  if(!missing(breaks)){
    if(length(breaks) != (length(col)+1)){stop("must have one more break than colour")}
  }
  if(missing(breaks) & !missing(zlim)){
    breaks <- seq(zlim[1], zlim[2], length.out=(length(col)+1)) 
  }
  if(missing(breaks) & missing(zlim)){
    zlim <- range(z, na.rm=TRUE)
    zlim[2] <- zlim[2]+c(zlim[2]-zlim[1])*(1E-3)#adds a bit to the range in both directions
    zlim[1] <- zlim[1]-c(zlim[2]-zlim[1])*(1E-3)
    breaks <- seq(zlim[1], zlim[2], length.out=(length(col)+1))
  }
  poly <- vector(mode="list", length(col))
  for(i in seq(poly)){
    poly[[i]] <- c(breaks[i], breaks[i+1], breaks[i+1], breaks[i])
  }
  xaxt <- ifelse(horiz, "s", "n")
  yaxt <- ifelse(horiz, "n", "s")
  if(horiz){YLIM<-c(0,1); XLIM<-range(breaks)}
  if(!horiz){YLIM<-range(breaks); XLIM<-c(0,1)}
  if(missing(xlim)) xlim=XLIM
  if(missing(ylim)) ylim=YLIM
  plot(1,1,t="n",ylim=ylim, xlim=xlim, xaxt=xaxt, yaxt=yaxt, xaxs="i", yaxs="i", ...)  
  for(i in seq(poly)){
    if(horiz){
      polygon(poly[[i]], c(0,0,1,1), col=col[i], border=NA)
    }
    if(!horiz){
      polygon(c(0,0,1,1), poly[[i]], col=col[i], border=NA)
    }
  }
}

