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

# Define params
E <- seq(0,1,le=100) # climatic suitability
c <- 1-E # Colonization rate
e <- 0.1/c # Extinction rate

# Plot
plot(x=E, y=1-e/c, ylim=c(0,1), type='l',
     lwd=lwd, yaxs="i", xaxs="i",
     yaxt='n', xaxt='n',
     cex.lab=2, cex.axis=1.5,
     ylab=expression(Prevalence), xlab='Time')
lines(y=1-E-0.1, x=E, lwd=lwd, lty=2)

# Box to frame the plot
box(lwd=lwd) 

# Close file
dev.off()

