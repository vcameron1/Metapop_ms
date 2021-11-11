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

plot.map3 <- function(scenarios <- c("RCP45_2020", "biomass_2020",
                                     "RCP45_2040", "biomass_2040", 
                                     "RCP45_2070", "biomass_2070",
                                     "RCP45_2100", "biomass_2100"),
                                     RL_cutoff = 0.005, extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143)){
    
    #### Scenarios ####
    filenames <- paste0("./SDM/results/BITH_", scenarios, ".tif")

    #### Loop through scenarios and plot them ####

    # Set up plot layout
    par(mfrow=c(4,2), mar=c(3,3,1,1))

    # Loop
    i=1
    for (map in filenames){

        # # Import projection
        r <- raster::raster(map)

        # # Limit analysis to current distribution
        e <- raster::extent(extent)
        r_sub <- raster::crop(r, e)

        # # Draw the map
        raster::plot(r_sub>=log(RL_cutoff), legend = FALSE, bty = "o", yaxs="i", xaxs="i",  col = c("darkkhaki", "darkgreen"), colNA = rgb(193/256,236/256,250/256), main = scenarios[i])

        i = i + 1
    }
}


