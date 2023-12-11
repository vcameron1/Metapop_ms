########################
# Function to plot SDM distribution projections
# Victor Cameron
# Mai 2022
# Updated april 2023
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
                    file_name = "./manuscript/img/map_BITH.png") {


    # 0 - Map parametres --------------------------------------------------


    # Plot bg
    bg = "transparent"

    # Colors
    cols = c("darkkhaki", NA, "darkgreen", "#FF4F00", "darkred")
    cols_inverse = c("grey50", "orange")

    # colNA
    colNA = NA

    # Title cex
    title_cex = 2
    legend_cex = 1.5


    # 1 - Import projections --------------------------------------------------


    #### Scenarios ####
    filenames <- paste0("./SDM/results/BITH_", scenarios, ".tif")

    # Québec shapefile map
    topo <- raster::raster("./data_clean/templateRaster.tif")

    # Québec contour map
    mask <- sf::read_sf("./data_clean/quebec_nad83.shp")
    mask_proj <- sf::st_transform(mask, raster::crs(topo))

    # Elevation map
    elevation <- elevatr::get_elev_raster(mask_proj, z = 5)
    elevation_reduced <- raster::crop(elevation, raster::extent(extent))
    elevation_reduced <- raster::mask(elevation_reduced, mask_proj)


    # 2 - Draw the map --------------------------------------------------------


    #### Loop through scenarios and plot them ####

    # Save plot in file
    png(file_name, width = 250, height = 50, units='mm', res = 200, bg=bg)

    # Set up plot layout
    par(mfrow = c(1, 4), mar = c(1, 1, 2, 1))

    # Loop
    i <- 1
    for (map in filenames) {

        # # Import projection
        r <- raster::raster(filenames[i])

        # # Limit analysis to current distribution
        e <- raster::extent(extent)
        r_sub <- raster::crop(r, e)

        # # Smooth background
        raster::plot(elevation_reduced > 0, legend=F,
             bty = "o", yaxs="i", xaxs="i", xaxt = "n", yaxt = "n", col = cols[1], colNA = colNA, main = main[i], cex.main = title_cex)

        # # Save if inital distribution
        if (i == 1) r_init <- r_sub >= log(RL_cutoff)

        # # Compute distribution
        # # # Current distribution
        distr_curr <- r_sub >= log(RL_cutoff)
        distr <- raster::setValues(r_init, NA)
        # # # Persistent distribution
        distr_pers <- distr_curr & r_init
        distr[distr_pers == TRUE] <- 1
        # # # Colonization distribution
        distr_col <- distr_curr > r_init
        distr[distr_col == TRUE] <- 2
        # # # Extinction distribution
        distr_ext <- distr_curr < r_init
        distr[distr_ext == TRUE] <- 3

        # # Set colors for persistent, colonized, and extinct distribution
        if (sum(raster::values(distr_col + distr_ext), na.rm = TRUE) == 0) {
            col = cols[2:3]
        } else {
            col = cols[3:5]
        }

        # # Draw the map
        raster::plot(distr,
            legend = FALSE, bty = "o", yaxs = "i", xaxs = "i", xaxt = "n", yaxt = "n", col = col, colNA = colNA, add = TRUE
        )
        
        # # Set legend for first map
        if (i == 1) {
            legend("bottomright", legend = c("Persistence", "Colonization", "Extinction"), fill = cols[3:5], bty = "n", cex = legend_cex)
        }

        # # Set scale bar and north arrow only for last map
        if(map == filenames[length(filenames)]) {
            # # Scale bar
            raster::scalebar(d=200000, xy=c(0, 1.5e+5), type='bar', divs=2, label = c(0, 100, 200), lonlat=FALSE, below = 'km', cex=legend_cex)
            # # North arrow
            arrows(x0=1e+5, x1=1e+5, y0=2.75e+5, y1=3.25e+5,
                    length=0.15, lwd=4)
            text(x=1e+5, y=2.5e+5, label = "N", cex=legend_cex, font=2)
        }

        i <- i + 1
    }

    # Close file
    dev.off()
}

# plot.map(file_name = "./manuscript/img/map_BITH.png")
# Full climate + forest projections
plot.map(scenarios = c("2020", "2040", "2070", "2100"),
    main = c("2020", "2040", "2070", "2100"),
    RL_cutoff = 0.00625, 
    extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143), 
    file_name = "./manuscript/img/map_full_BITH.png")
