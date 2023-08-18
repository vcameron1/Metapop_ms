########################
# Plot of the BITH persistence changes
# Victor Cameron
# Mai 2022
#########################

# Metrics
BITH_metrics_QC <- readRDS("./SDM/results/BITH_metrics_QC.RDS")


#### Area ####

totalArea_QC <- data.frame(totalArea = BITH_metrics_QC$totalArea, scenario = names(BITH_metrics_QC$totalArea), Time = 2020)

# Create Time column
totalArea_QC$Time[totalArea_QC$scenario %in% c("BITH_RCP45_2020","BITH_biomass_2020")] <- 2020
totalArea_QC$Time[totalArea_QC$scenario %in% c("BITH_RCP45_2040","BITH_biomass_2040")] <- 2040
totalArea_QC$Time[totalArea_QC$scenario %in% c("BITH_RCP45_2070","BITH_biomass_2070")] <- 2070
totalArea_QC$Time[totalArea_QC$scenario %in% c("BITH_RCP45_2100","BITH_biomass_2100")] <- 2100

# Rename scenarios
totalArea_QC$scenario[totalArea_QC$scenario %in% c("BITH_RCP45_2020","BITH_RCP45_2040","BITH_RCP45_2070","BITH_RCP45_2100")] <- "Climate-only"
totalArea_QC$scenario[totalArea_QC$scenario %in% c("BITH_biomass_2020","BITH_biomass_2040","BITH_biomass_2070","BITH_biomass_2100")] <- "Forest composition"

# Rescale taotalArea
totalArea_QC$totalArea <- totalArea_QC$totalArea/totalArea_QC$totalArea[1]

#### Capacity ####

capacity_QC <-  cbind(BITH_metrics_QC$capacity, Time = 2020)

# Create Time column
capacity_QC$Time[capacity_QC$scenario %in% c("BITH_RCP45_2020","BITH_biomass_2020")] <- 2020
capacity_QC$Time[capacity_QC$scenario %in% c("BITH_RCP45_2040","BITH_biomass_2040")] <- 2040
capacity_QC$Time[capacity_QC$scenario %in% c("BITH_RCP45_2070","BITH_biomass_2070")] <- 2070
capacity_QC$Time[capacity_QC$scenario %in% c("BITH_RCP45_2100","BITH_biomass_2100")] <- 2100

# Rename scenarios
capacity_QC$scenario[capacity_QC$scenario %in% c("BITH_RCP45_2020","BITH_RCP45_2040","BITH_RCP45_2070","BITH_RCP45_2100")] <- "Climate-only"
capacity_QC$scenario[capacity_QC$scenario %in% c("BITH_biomass_2020","BITH_biomass_2040","BITH_biomass_2070","BITH_biomass_2100")] <- "Forest composition"

# Subset data
capacity_QC <- capacity_QC[capacity_QC$alpha %in% c(1,0.002),]

# Rescale capacity
capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==1] <- capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==1]/capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==1][1]

capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==0.002] <- capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==0.002]/capacity_QC$capacity[capacity_QC$scenario=="Climate-only" & capacity_QC$alpha==0.002][1]

capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==1] <- capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==1]/capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==1][1]

capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==0.002] <- capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==0.002]/capacity_QC$capacity[capacity_QC$scenario=="Forest composition" & capacity_QC$alpha==0.002][1]

#### Plot ####

# Set graphic parameters
lwd <- 3
cex_lab <- 1.5


# Save plot in file
png('./manuscript/img/capacity.png', width = 200*1.2, height = 75*1.2, units='mm', res = 200)

# Par
par(mfrow = c(1, 2), mar = c(5, 4, 1, 1))

# Plot climate-only
## Climate only - habitat amount -
plot(totalArea_QC$Time[totalArea_QC$scenario == "Climate-only"],
    totalArea_QC$totalArea[totalArea_QC$scenario == "Climate-only"],
    type = "b", col = "darkblue", ylab = "", xlab = "Time", cex.lab = cex_lab,
    lwd = lwd, yaxt = "n", axes = FALSE, ylim = c(0.8, 1.8)
)
## Climate only - plot layout -
box(bty = "l")
axis(1)
title(ylab = "Metrics of\npersistence", line = 1, cex.lab = cex_lab)
# legend(2065, 2, legend=c("Habitat amount", "Capacity", "1 km dispersal", "500 km dispersal"), col=c("darkblue","darkgrey","darkgrey","darkgrey"), lty=c(1,1,2:3), lwd=2, cex=0.7, box.lty=0)
legend(2060, 1.9,
    legend = c("Habitat amount", "Capacity (1 km)", "Capacity (500 km)"),
    col = c("darkblue", "darkgrey", "darkgrey"), lty = c(1:3),
    lwd = lwd, cex = 0.9, box.lty = 0
)
## Climate only - capacity 1km -
par(new = TRUE)
plot(capacity_QC$Time[capacity_QC$scenario == "Climate-only" &
        capacity_QC$alpha == 1],
    capacity_QC$capacity[capacity_QC$scenario == "Climate-only" &
        capacity_QC$alpha == 1],
    type = "b", col = "darkgrey", lty = 2, lwd = lwd, axes = FALSE,
    bty = "n", xlab = "", ylab = "", ylim = c(-0.26, 6)
)
## Climate only - capacity 500km -
par(new = TRUE)
plot(capacity_QC$Time[capacity_QC$scenario == "Climate-only" &
        capacity_QC$alpha == 0.002],
    capacity_QC$capacity[capacity_QC$scenario == "Climate-only" &
        capacity_QC$alpha == 0.002],
    type = "b", col = "darkgrey", lty = 3, lwd = lwd, axes = FALSE,
    bty = "n", xlab = "", ylab = "", ylim = c(-0.7, 7.4)
)

# Plot forest-change
par(mar = c(5, 4, 1, 1))
## Forest change - habitat amount -
plot(totalArea_QC$Time[totalArea_QC$scenario == "Forest composition"],
    totalArea_QC$totalArea[totalArea_QC$scenario == "Forest composition"],
    type = "b", col = "darkorange", ylab = "", xlab = "Time",
    cex.lab = cex_lab, lwd = lwd, yaxt = "n", axes = FALSE, ylim = c(0.7, 1.5)
)
## Forest change - plot layout -
box(bty = "l")
axis(1)
## Forest change - capacity 1km -
par(new = TRUE)
plot(capacity_QC$Time[capacity_QC$scenario == "Forest composition" &
        capacity_QC$alpha == 1],
    capacity_QC$capacity[capacity_QC$scenario == "Climate-only" &
        capacity_QC$alpha == 1],
    type = "b", col = "darkgrey", lty = 2, lwd = lwd, axes = FALSE,
    bty = "n", xlab = "", ylab = "", ylim = c(-0.3, 3.2)
)
## Forest change - capacity 500km -
par(new = TRUE)
plot(capacity_QC$Time[capacity_QC$scenario == "Forest composition" &
        capacity_QC$alpha == 0.002],
    capacity_QC$capacity[capacity_QC$scenario == "Forest composition" &
        capacity_QC$alpha == 0.002],
    type = "b", col = "darkgrey", lty = 3, lwd = lwd, axes = FALSE,
    bty = "n", xlab = "", ylab = "", ylim = c(-0.3, 3.2)
)

# Close plot
dev.off()