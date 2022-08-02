########################
# Function to plot SDM distribution projections
# Victor Cameron
# Mai 2022
#########################


plot.map <- function(scenarios = c("RCP45_2020", "biomass_2020",
                                     "RCP45_2040", "biomass_2040", 
                                     "RCP45_2070", "biomass_2070",
                                     "RCP45_2100", "biomass_2100"),
                    main = c("2020", "2020",
                             "Climate-only 2040", "Forest change 2040",
                             "Climate-only 2070", "Forest change 2070",
                             "Climate-only 2100", "Forest change 2100"),
                    RL_cutoff = 0.00625, extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143), 
                    file_name = "./manuscript/img/map_GRBI.png") {


    # 0 - Map parametres --------------------------------------------------


    # Plot bg
    bg = "transparent"

    # Colors
    cols = c("darkkhaki", NA, "darkgreen") #c("grey80", "darkgreen")
    cols_inverse = c("grey50", "orange")

    # colNA
    colNA = NA

    # Title cex
    title_cex = 1.5


    # 1 - Import projections --------------------------------------------------


    #### Scenarios ####
    filenames <- paste0("/Users/victorcameron/Documents/Git/Metapop_ms/SDM/results/BITH_", scenarios, ".tif")

    # Québec shapefile map
    topo <- raster::raster("/Users/victorcameron/Documents/Git/Metapop_ms/data_clean/templateRaster.tif")

    # Québec contour map
    mask <- sf::read_sf("/Users/victorcameron/Documents/Git/Metapop_ms/data_clean/quebec_nad83.shp")
    mask_proj <- sf::st_transform(mask, raster::crs(topo))

    # Elevation map
    elevation <- elevatr::get_elev_raster(topo, z = 5)
    elevation_reduced <- raster::crop(elevation, raster::extent(extent))
    elevation_reduced <- raster::mask(elevation_reduced, mask_proj)


    # 2 - Draw the map --------------------------------------------------------


    #### Loop through scenarios and plot them ####

    # Save plot in file
    png(file_name, width = 207, height = 250, units='mm', res = 200, bg=bg)

    # Set up plot layout
    par(mfrow = c(4, 2), mar = c(1, 1, 2, 1))

    # Loop
    i <- 1
    for (map in filenames) {

        # # Import projection
        r <- raster::raster(map)

        # # Limit analysis to current distribution
        e <- raster::extent(extent)
        r_sub <- raster::crop(r, e)

        # # Smooth background
        raster::plot(elevation_reduced > 0, legend=F,
             bty = "o", yaxs="i", xaxs="i", xaxt = "n", yaxt = "n", col = cols[1], colNA = colNA, main = main[i], cex.main = title_cex)

        # # Draw the map
        raster::plot(r_sub >= log(RL_cutoff),
            legend = FALSE, bty = "o", yaxs = "i", xaxs = "i", xaxt = "n", yaxt = "n", col = cols[2:3], colNA = colNA, add = TRUE
        )

        if(map == filenames[length(filenames)]) {
            # # Scale bar
            raster::scalebar(d=200000, xy=c(0, 1.4e+5), type='bar', divs=2, label = c(0, 100, 200), lonlat=FALSE, below = 'km')
            # # North arrow
            arrows(x0=1e+5, x1=1e+5, y0=2.5e+5, y1=3e+5,
                    length=0.15, lwd=4)
            text(x=1e+5, y=2.3e+5, label = "N", cex=1, font=2)
        }

        i <- i + 1
    }

    # Close file
    dev.off()
}

plot.map()
