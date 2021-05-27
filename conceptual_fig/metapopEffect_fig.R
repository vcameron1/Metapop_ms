#### 
# title: Metapopulation effect conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

# Save plot in file
png('../manuscript/img/concept_metapopEffect.png', width = 150, height = 150, units='mm', res = 700)

# Set graphic parameters
par(pty = "s",par(pty = "s", mar=c(4.5,4.5,1,0)))
lwd <- 4

# Environmetal gradient
seq <- seq(0.5, 1, le=20)

# Compute consumer occupancy 
occ <- vector()
i=1
for(E in seq){
   occ[i] <- consumerOcc(resOpt=0.5, consOpt=0.5, E=E)
   i = i + 1
}

# Plot
plot(x=seq, y=occ, ylim=c(0,1.1), xlim=c(0.5,1), type='l',
     lwd=lwd, yaxs="i", xaxs="i",
     yaxt='n', xaxt='n',
     cex.lab=2, cex.axis=1.5,
     ylab='', xlab='')
lines(y=c(1,0), x=range(seq), lwd=lwd, lty=2)

# Axis titles
title(ylab = "Prevalence",
      xlab='Time',
      cex.lab = 1.5, line = 1)

# Box to frame the plot
box(lwd=lwd) 

# Close file
dev.off()
