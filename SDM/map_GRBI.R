# Function to plot SDM distribution projections

plot.map <- function(projRaster_path = "./SDM/results/projections_GRBI.RDS", extent = c(xmin = -75, xmax = -64, ymin = 45, ymax = 49.5), file_name = "./SDM/results/map_GRBI.png"){


    # 1 - Import projections --------------------------------------------------


    SDM <- readRDS(projRaster_path)

    # # Limit analysis to current distribution
    e <- raster::extent(extent)
    SDM_sub <- raster::crop(SDM, e)


    # 2 - Draw the map --------------------------------------------------------


    # Save plot in file
    png(file_name, width = 250, height = 170, units='mm', res = 500)

    # South of Quebec base plot
    raster::plot(SDM_sub[[1]], legend = F, bty = "o", yaxs="i", xaxs="i",  col = "darkkhaki", colNA = rgb(193/256,236/256,250/256))

    # Scale bar
    raster::scalebar(200, xy=c(-67.5, 45.2), type='bar', divs=4, lonlat=TRUE, adj=c(1,-2))

    # Initial distribution contour
    raster::contour(SDM_sub[[1]]>=log(0.05), fill = "black",lwd=3, add=TRUE, drawlabels=FALSE)

    # +2°C distribution contour
    raster::contour(SDM_sub[[11]]>=log(0.05), col='darkgreen', lwd=1, add=TRUE, drawlabels=FALSE)

    # +4°C distribution contour
    raster::contour(SDM_sub[[21]]>=log(0.05), col='darkred', lwd=1, add=TRUE, drawlabels=FALSE)

    # Legend
    legend(-68, 47, legend = c("Current distribution", "Distribution at +2°C", "Distribution at +4°C"), col = c("black", "darkgreen", "darkred"), bty = 'n', lty = 1, ltw = 2)

    # Close file
    dev.off()
}

plot.map3 <- function(projRaster_path = "/Users/victorcameron/Documents/Git/Metapop_ms/SDM/results/projections_GRBI.RDS", extent = c(xmin = -75, xmax = -64, ymin = 45, ymax = 49.5)){
    
    
    # 1 - Import projections --------------------------------------------------


    SDM <- readRDS(projRaster_path)

    # # Limit analysis to current distribution
    e <- raster::extent(extent)
    SDM_sub <- raster::crop(SDM, e)


    # 2 - Draw the map --------------------------------------------------------


    par(mfrow=c(raster::nlayers(SDM)/2,2), mar=c(3,3,1,1))
    for(i in 1:raster::nlayers(SDM)){
        raster::plot(SDM_sub[[i]]>=log(0.05), legend = F, bty = "o", yaxs="i", xaxs="i",  col = c("darkkhaki", "darkgreen"), colNA = rgb(193/256,236/256,250/256), main = names(SDM_sub[[i]]))
    }
}


