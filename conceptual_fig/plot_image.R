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
