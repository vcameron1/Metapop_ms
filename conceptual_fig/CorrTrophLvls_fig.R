#### 
# title: Environmental correlation between trophic levels conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

#### Function to generate CorrTrophLvls plot and colorscale ####

CorrTroph_plot <- function(){
  # Dependencies
  source('./conceptual_fig/2spMetapop_model.R')
  source('./conceptual_fig/smallCorrTrophLvls_fig.R')
  
  # Genrate small plots
  smallCorrTrophLvls_fig()
  
  # Parameters
  lwd = 4
  ftr=0.19
  pos <- list(c1=c(0.4,0.6),
              c2=c(0.6,0.65),
              c3=c(0.35,0.4),
              c4=c(0.4,0.6))
  E <- seq(0,1, le=100)
  
  # x y coordinates of the plot
  x <- y <- seq(0, 1, by=0.025)
  
  # Matrix to store prevalences
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
  
  
  # Plot heatmap
  png('./manuscript/img/concept_CorrTrophLvls.png', width = 150, height = 150, units='mm', res = 700)
  par(pty = "s",par(pty = "s", mar=c(3,3,1,0)))
  
  ## Center color range on 0
  cols <- hcl.colors(length(z), "Red-Green")
  max_abs <- max(abs(z))
  brk <- lattice::do.breaks(c(-max_abs, max_abs), length(c(z)))
  first_true <- which.max(brk > min(c(z)))
  last_true <- which.min(brk < max(c(z)))
  brk <- brk[1:(last_true +1)]
  cols <- cols[1:(last_true)]
  
  ## Plot
  image(z, col=cols, breaks = brk,
        lwd=lwd, yaxs="i", xaxs="i",
        yaxt='n', xaxt='n',
        cex.lab=2, cex.axis=1.5,
        ylab='', xlab='')
  abline(0, 1, lty=2)
  abline(h=0.5)
  abline(v=0.5)
  title(ylab='High trophic level optimum (E)',
        xlab='Low trophic level optimum (E)',
        cex.lab = 1.5, line = 1)
  box(lwd=lwd) 
  
  ## Indicator plots
  plotimage(file = "./manuscript/img/concept_c1.png", size = 0.2, x=0.1, y=0.9, add = T)
  plotimage(file = "./manuscript/img/concept_c2.png", size = 0.2, x=0.6, y=0.9, add = T)
  plotimage(file = "./manuscript/img/concept_c3.png", size = 0.2, x=0.1, y=0.4, add = T)
  plotimage(file = "./manuscript/img/concept_c4.png", size = 0.2, x=0.6, y=0.4, add = T)
  
  ## Close file
  dev.off()
  
  
  # Plot color scale
  png('./manuscript/img/concept_ColorScale.png', width = 25, height = 100, units='mm', res = 700)
  par(pty = "m", mar=c(5,1,5,3))
  image.scale(brk, col=cols, horiz=F, cex=0.75)
  mtext(side = 3, line = 1, text = "       Delta \n       occupancy", font = 1, cex=0.75)
  box()
  
  ## Close file
  dev.off()
}





#### Function to add a scale to the image() function ####

# It is important to remember that for the scales to appear next to the plots, the layout must be correctly specified
#layout(matrix(c(1,2,3,0,4,0), nrow=2, ncol=3), widths=c(4,4,1), heights=c(4,1))
#layout.show(4)

image.scale <- function(z, zlim, col = heat.colors(12),
                        breaks, horiz=TRUE, ylim=NULL, xlim=NULL,
                        ylab='', xlab='', cex=1, ...){
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
  plot(1,1,t="n",ylim=ylim, xlim=xlim, axes = FALSE, xaxt=xaxt, yaxt=yaxt, xaxs="i", yaxs="i", ylab=ylab, xlab=xlab, ...)  
  if(!horiz){axis(4, las=1, cex.axis=cex)}
  if(horiz){axis(2)}
  for(i in seq(poly)){
    if(horiz){
      polygon(poly[[i]], c(0,0,1,1), col=col[i], border=NA)
    }
    if(!horiz){
      polygon(c(0,0,1,1), poly[[i]], col=col[i], border=NA)
    }
  }
}


#### Function to add image ####

plotimage <- function(file, x = NULL, y = NULL, size = 1, add = FALSE,
                        angle = 0, pos = 0, bg = "lightgray", ...){
  if (length(grep(".png", file)) > 0) { 
    require("png")
    img <- readPNG(file, native = TRUE)
  }
  if (length(grep(".tif", file)) > 0) { 
    require("tiff")
    img <- readTIFF(file, native = TRUE)
  }
  if (length(grep(".jp", file)) > 0) { 
    require("jpeg")
    img <- readJPEG(file, native = TRUE)
  }
     res <- dim(img)[2:1]

  if (add) {
    xres <- par()$usr[2] - par()$usr[1] 
    yres <- par()$usr[4] - par()$usr[3] 
    res <- c(xres, yres)
  }else{
    par(mar = c(1, 1, 1, 1), bg = bg, xaxs = "i", yaxs = "i")
    dims <- c(0, max(res))
    plot(0, type = "n", axes = F, xlim = dims, ann = F, ylim = dims,
       ...)
  }
  if (is.null(x) && is.null(y)) {
    if (pos == "center" || pos == 0) {
      x <- par()$usr[1] + (par()$usr[2] - par()$usr[1])/2
      y <- par()$usr[3] + (par()$usr[4] - par()$usr[3])/2
    }
    if (pos == "bottom" || pos == 1) {
      x <- par()$usr[1] + (par()$usr[2] - par()$usr[1])/2
      y <- par()$usr[3] + res[2] * size/2
    }
    if (pos == "left" || pos == 2) {
      x <- par()$usr[1] + res[1] * size/2 
      y <- par()$usr[3] + (par()$usr[4] - par()$usr[3])/2 
    }
    if (pos == "top" || pos == 3) {
      x <- par()$usr[1] + (par()$usr[2] - par()$usr[1])/2
      y <- par()$usr[4] - res[2] * size/2
    }
    if (pos == "right" || pos == 4) {
      x <- par()$usr[2] - res[1] * size/2 
      y <- par()$usr[3] + (par()$usr[4] - par()$usr[3])/2
    }
    if (pos == "bottomleft" || pos == 5) { 
      x <- par()$usr[1] + res[1] * size/2 
      y <- par()$usr[3] + res[2] * size/2
    }
    if (pos == "topleft" || pos == 6) {
      x <- par()$usr[1] + res[1] * size/2 
      y <- par()$usr[4] - res[2] * size/2
    }
    if (pos == "topright" || pos == 7) {
      x <- par()$usr[2] - res[1] * size/2 
      y <- par()$usr[4] - res[2] * size/2
    }
    if (pos == "bottomright" || pos == 8) { 
      x <- par()$usr[2] - res[1] * size/2 
      y <- par()$usr[3] + res[2] * size/2
    }
  }
    xx <- res[1] * size/2
    yy <- res[2] * size/2
    rasterImage(img, x - xx, y - yy, x + xx, y + yy, angle = angle) 
}

