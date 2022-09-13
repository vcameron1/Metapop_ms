#### 
# Script that makes the conceptual figure about occupancy.
# author: Victor Cameron
# date: 12/09/2022
####

# Dependencies
source("./conceptual_fig/persistence_fig.R")
source("./conceptual_fig/plot_image.R")

# Plot parameters
cex_lab <- 2

# Generate plots
## Pannel 1
ec_curve <- function(x) 0.5 * x + 0.08
H_curve <- function(x) 0.75 - (0.4 * x)
persistence_plot(ec_curve, H_curve, plot_name = "decrease_occ_plot")
## Pannel 2
ec_curve <- function(x) 0.8 * x + 0.1
H_curve <- function(x) 0.8 * x + 0.3
persistence_plot(ec_curve, H_curve, plot_name = "stable_occ_plot")
## Pannel 3
ec_curve <- function(x) 0.5 * x + 0.08
H_curve <- function(x) 0.95 * x + 0.25
persistence_plot(ec_curve, H_curve, plot_name = "increase_occ_plot")


# Save plot in file
png('./manuscript/img/concept_occ.png', width = 500, height = 150, units='mm', res = 700)

par(fig=c(0,0.33,0,1))
plotimage(file = "./manuscript/img/decrease_occ_plot.png", size = 1, add = F, bg = "white")
mtext("A)", adj=0, line=-1.5, cex=cex_lab)
par(fig=c(0.33,0.66,0,1), new=TRUE)
plotimage(file = "./manuscript/img/stable_occ_plot.png", size = 1, add = T, bg = "white")
mtext("B)", adj=0, line=-1.5, cex=cex_lab)
par(fig=c(0.66,1,0,1), new=TRUE)
plotimage(file = "./manuscript/img/increase_occ_plot.png", size = 1, add = T, bg = "white")
mtext("C)", adj=0, line=-1.5, cex=cex_lab)

# Close file
dev.off()

# Remove temporary plots
file.remove("./manuscript/img/decrease_occ_plot.png")
file.remove("./manuscript/img/stable_occ_plot.png")
file.remove("./manuscript/img/increase_occ_plot.png")
