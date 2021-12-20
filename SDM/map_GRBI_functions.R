# Function to plot SDM distribution projections

plot.map <- function(scenarios = c("RCP45_2020", "biomass_2020",
                                     "RCP45_2040", "biomass_2040", 
                                     "RCP45_2070", "biomass_2070",
                                     "RCP45_2100", "biomass_2100"),
                    main = c("Climate-only 2020", "Forest composition 2020",
                             "Climate-only 2040", "Forest composition 2040",
                             "Climate-only 2070", "Forest composition 2070",
                             "Climate-only 2100", "Forest composition 2100"),
                    RL_cutoff = 0.00625, extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143), 
                    file_name = "./SDM/results/map_GRBI.png"){


    # 1 - Import projections --------------------------------------------------


    #### Scenarios ####
    filenames <- paste0("/Users/victorcameron/Documents/Git/Metapop_ms/SDM/results/BITH_", scenarios, ".tif")


    # 2 - Draw the map --------------------------------------------------------

    
    #### Loop through scenarios and plot them ####

    # Save plot in file
    png(file_name, width = 202, height = 250, units='mm', res = 200)

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
        raster::plot(r_sub>=log(RL_cutoff), legend = FALSE, bty = "o", yaxs="i", xaxs="i",  col = c("darkkhaki", "darkgreen"), colNA = rgb(193/256,236/256,250/256), main = main[i])

        i = i + 1
    }

    # Close file
    dev.off()
}

plot.map3 <- function(scenarios = c("RCP45_2020", "biomass_2020",
                                     "RCP45_2040", "biomass_2040", 
                                     "RCP45_2070", "biomass_2070",
                                     "RCP45_2100", "biomass_2100"),
                                     RL_cutoff = 0.005, extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143)){
    
    #### Scenarios ####
    filenames <- paste0("/Users/victorcameron/Documents/Git/Metapop_ms/SDM/results/BITH_", scenarios, ".tif")

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


