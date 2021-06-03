#### 
# title: Metapopulation effect conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

# Dependencies
source('./conceptual_fig/2spMetapop_model.R')

# Save plot in file
png('./manuscript/img/concept_metapopEffect.png', width = 150, height = 150, units='mm', res = 700)

# Set graphic parameters
par(pty = "s",par(pty = "s", mar=c(4.5,4.5,1,0)))
lwd <- 4

# Environmetal gradient
time <- 20
Env <- seq(0.5, 1, le=time)

# Compute consumer occ2upancy in 2 sp metapop model and single species model
occ2 <- vector()
occ1 <- vector()
i=1
for(E in Env){
   occ2[i] <- consumerOcc(resOpt=0.5, consOpt=0.5, E=E)
   occ1[i] <- consumerOcc(resOpt=0.5, consOpt=0.5, E=E, consumer=FALSE)
   i = i + 1
}

# Plot
plot(x=1:time, y=occ2, ylim=c(0,max(occ2)+.1), type='l',
     lwd=lwd, yaxs="i", xaxs="i",
     yaxt='n', xaxt='n',
     cex.lab=2, cex.axis=1.5,
     ylab='', xlab='')
lines(y=occ1, x=1:time, lwd=lwd, lty=2)

# Axis titles
title(ylab = "Prevalence",
      xlab='Time',
      cex.lab = 1.5, line = 1)

# Box to frame the plot
box(lwd=lwd) 

# Close file
dev.off()
