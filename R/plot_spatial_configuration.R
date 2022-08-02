########################
# Plot of the changes in the spatial configuration of the distribution
# Victor Cameron
# Mai 2022
#########################

# Metrics
BITH_metrics_QC <- readRDS("/Users/victorcameron/Documents/Git/Metapop_ms/SDM/results/BITH_metrics_QC.RDS")

#### Figure format ####

# Save plot in file
png('./manuscript/img/spatial_configuration.png', width = 200, height = 60, units='mm', res = 200)

# Par
par(mfrow=c(1,3), mar=c(5,6,1,1))

#### Patch number ####

# Extract number of patches
n_QC <- data.frame(n = BITH_metrics_QC$n, Time = c(2020, 2040, 2070, 2100), scenario = c(rep("Climate-only",4),rep("Forest composition",4)))

# Plot number of patches
plot(n_QC$Time[n_QC$scenario=="Climate-only"], n_QC$n[n_QC$scenario=="Climate-only"], type = "b", col = "darkblue", ylim = c(1000, 7000),
    ylab = "Number of patches", xlab = "Time", cex.lab  = 1.5, lwd=2, axes=FALSE)
box(bty="l")
axis(1)
axis(2)
lines(n_QC$Time[n_QC$scenario=="Forest composition"], n_QC$n[n_QC$scenario=="Forest composition"], type = "b", lwd=2, col = "darkorange")
legend(2060, 7000, legend=c("Climate-only", "Forest change"), col=c("darkblue","darkorange"), lty=1, lwd=2, cex=0.7, box.lty=0)


#### Patch area ####

# Create Time variable
area_QC <- data.frame(area = BITH_metrics_QC$patchArea$area, Time = BITH_metrics_QC$patchArea$scenario, scenario = BITH_metrics_QC$patchArea$scenario)
area_QC$Time[area_QC$Time %in% c("BITH_RCP45_2020","BITH_biomass_2020")] <- 2020
area_QC$Time[area_QC$Time %in% c("BITH_RCP45_2040","BITH_biomass_2040")] <- 2040
area_QC$Time[area_QC$Time %in% c("BITH_RCP45_2070","BITH_biomass_2070")] <- 2070
area_QC$Time[area_QC$Time %in% c("BITH_RCP45_2100","BITH_biomass_2100")] <- 2100

# Aggregate data do get median
area_QC <- aggregate(area_QC$area, by = list(area_QC$scenario, area_QC$Time), FUN = median) 
area_QC$scenario[area_QC$Group.1 %in% c("BITH_RCP45_2020","BITH_RCP45_2040","BITH_RCP45_2070","BITH_RCP45_2100")] <- "Climate-only"
area_QC$scenario[area_QC$Group.1 %in% c("BITH_biomass_2020","BITH_biomass_2040","BITH_biomass_2070","BITH_biomass_2100")] <- "Forest composition"

# Rename some variables
area_QC$Time <- area_QC$Group.2
area_QC$area <- area_QC$x

# Plot patch area median
plot(area_QC$Time[area_QC$scenario=="Climate-only"], area_QC$area[area_QC$scenario=="Climate-only"], type = "b", col = "darkblue", ylab = expression("Median patch area (km"^2*")"), xlab = "Time", ylim = c(0.1,0.35), cex.lab  = 1.5,lwd=2, axes=FALSE)
box(bty="l")
axis(1)
axis(2)
lines(area_QC$Time[area_QC$scenario=="Forest composition"], area_QC$area[area_QC$scenario=="Forest composition"], type = "b", lwd=2, col = "darkorange")

#### Inter-patch distance ####

# Function to extract distance
extract.dist <- function(metrics){
    dist <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("dist", "scenario"))
    for(i in seq_along(metrics$n)){
        if(metrics$n[i] == 0) next
        dij <- metrics$d_ij[[i]][lower.tri(metrics$d_ij[[i]], diag = FALSE)]
        scenario <- names(metrics$d_ij[i])

        dist <- rbind(dist, data.frame(dij, scenario))
    }
    colnames(dist) <- c("dist", "scenario")
    #dist$scenario <- as.factor(dist$scenario)
    
    return(dist)
}

# Extract distance
dist_QC <- cbind(extract.dist(BITH_metrics_QC), Time = 2020)

# Create Time column
dist_QC$Time[dist_QC$scenario %in% c("BITH_RCP45_2020","BITH_biomass_2020")] <- 2020
dist_QC$Time[dist_QC$scenario %in% c("BITH_RCP45_2040","BITH_biomass_2040")] <- 2040
dist_QC$Time[dist_QC$scenario %in% c("BITH_RCP45_2070","BITH_biomass_2070")] <- 2070
dist_QC$Time[dist_QC$scenario %in% c("BITH_RCP45_2100","BITH_biomass_2100")] <- 2100

# Aggregate data do get median
dist_QC <- aggregate(dist_QC$dist, by = list(dist_QC$scenario, dist_QC$Time), FUN = median)
dist_QC$scenario[dist_QC$Group.1 %in% c("BITH_RCP45_2020","BITH_RCP45_2040","BITH_RCP45_2070","BITH_RCP45_2100")] <- "Climate-only"
dist_QC$scenario[dist_QC$Group.1 %in% c("BITH_biomass_2020","BITH_biomass_2040","BITH_biomass_2070","BITH_biomass_2100")] <- "Forest composition"

# Rename some variables
dist_QC$Time <- dist_QC$Group.2
dist_QC$dist <- dist_QC$x

# Plot patch dist median
plot(dist_QC$Time[dist_QC$scenario=="Climate-only"], dist_QC$dist[dist_QC$scenario=="Climate-only"], type = "b", col = "darkblue", ylab = "Median inter-patch \ndistance (km)", xlab = "Time", ylim = c(215,280), cex.lab = 1.5,lwd=2, axes=FALSE)
box(bty="l")
axis(1)
axis(2)
lines(dist_QC$Time[dist_QC$scenario=="Forest composition"], dist_QC$dist[dist_QC$scenario=="Forest composition"], type = "b", lwd=2, col = "darkorange")

# Close file
dev.off()