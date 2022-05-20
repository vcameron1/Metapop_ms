#### 
# title: Metapopulation effect conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

metapopEffect_plot <- function(){
   # Dependencies
   source('./conceptual_fig/2spMetapop_model.R')
   
   # Save plot in file
   png('./manuscript/img/concept_metapopEffect.png', width = 150, height = 150, units='mm', res = 700)
   
   # Set graphic parameters
   par(pty = "s", par(pty = "s", mar = c(3, 3, 1, 0)), bg = NA)
   lwd <- 6
   
   # Constants
   e <- 0.1
   c <- 0.9
   
   # Environmetal gradient
   time <- 100
   Env <- seq(1, 0, le=time)
   
   # Parameters
   h <- Env
   A <- Env
   
   # Plot
   plot(x=Env, y=h-(e/c), ylim=c(0,1), xlim = c(1,0),type='l',
        lwd=lwd, yaxs="i", xaxs="i",
        yaxt='n', xaxt='n',
        cex.lab=2, cex.axis=1.8,
        ylab='', xlab='')
   lines(x=Env, y=h-(e/(A^2*c)), lwd=lwd, lty=2)
   
   # Axis titles
   title(ylab = "Prevalence",
         xlab='Time',
         cex.lab = 1.8, line = 1)
   
   # Box to frame the plot
   box(lwd=lwd) 
   
   # Close file
   dev.off()
}