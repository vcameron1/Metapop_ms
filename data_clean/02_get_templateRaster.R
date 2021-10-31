#############################################################
## Generate an template raster* for the south of Quebec and regions
## Victor Cameron
## July 2021
#############################################################

#############################################################
## Data are projected in lcc
## Resolution is of 250x250m
#############################################################


# 1 - Full extent ---------------------------------------------------------


# Initiate raster based upon forest biomass projections
load("RCP45_GrowthBudwormBaselineFire_ABIE.BAL_0_merged.RData")
template <- MergedRasters >= 0

# Save template
raster::writeRaster(template, filename="./data_clean/templateRaster.tif", overwrite=TRUE)


# 2 - Québec region -------------------------------------------------------


tempale_QC <- template

raster::extent(tempale_QC) <- c(xmin = -612379,
                                xmax = 376211,
                                ymin = 118014.3,
                                ymax = 820678)


# 3 - Réserve faunique des Laurentides region -----------------------------


tempale_RL <- template

raster::extent(tempale_RL) <- c(xmin = -282986,
                                xmax = -109983,
                                ymin = 311761,
                                ymax = 475079)


# 4 - Easter Townships region ---------------------------------------------


tempale_ET <- template

raster::extent(tempale_ET) <- c(xmin = -356488,
                                xmax = -115085,
                                ymin = 111680,
                                ymax = 234873)
