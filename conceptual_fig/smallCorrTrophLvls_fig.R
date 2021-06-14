#### 
# title: Visual distributions for environmental correlation between trophic levels conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

smallCorrTrophLvls_fig <- function(){
        
        #### Params ####
        
        lwd=1
        ftr=0.19
        pos <- list(c1=c(0.4,0.6),
                    c2=c(0.6,0.65),
                    c3=c(0.35,0.4),
                    c4=c(0.4,0.6))
        E <- seq(0,1, le=100)
        
        
        #### c1 ####
        
        # Save plot in file
        png('./manuscript/img/concept_c1.png', width = 150, height = 75, units='mm', res = 700)
        
        # Transparent background
        par(bg=NA)
        
        # plot
        plot(ftr*dnorm(E, mean = pos[['c1']][1], sd = 0.08), x=E, type='l',
             ylim=c(0,1),
             lwd=lwd, 
             yaxs="i", xaxs="i",
             axes=F,
             ylab='', xlab='')
        lines(ftr*dnorm(E, mean = pos[['c1']][2], sd = 0.08), x=E)
        axis(side=1, pos=0, lwd.ticks=0, labels=FALSE, lwd=lwd+1)
        abline(v=0.5, lty=2)
        
        # Close file
        dev.off()
        
        
        #### c2 ####
        
        # Save plot in file
        png('./manuscript/img/concept_c2.png', width = 150, height = 75, units='mm', res = 700)
        
        # Transparent backgrounf
        par(bg=NA)
        
        # plot
        plot(ftr*dnorm(E, mean = pos[['c2']][1], sd = 0.08), x=E, type='l',
             ylim=c(0,1),
             lwd=lwd, 
             yaxs="i", xaxs="i",
             axes=F,
             ylab='', xlab='')
        lines(ftr*dnorm(E, mean = pos[['c2']][2], sd = 0.08), x=E)
        axis(side=1, pos=0, lwd.ticks=0, labels=FALSE, lwd=lwd+1)
        abline(v=0.5, lty=2)
        
        # Close file
        dev.off()
        
        
        #### c3 ####
        
        # Save plot in file
        png('./manuscript/img/concept_c3.png', width = 150, height = 75, units='mm', res = 700)
        
        # Transparent backgrounf
        par(bg=NA)
        
        # plot
        plot(ftr*dnorm(E, mean = pos[['c3']][1], sd = 0.08), x=E, type='l',
             ylim=c(0,1),
             lwd=lwd, 
             yaxs="i", xaxs="i",
             axes=F,
             ylab='', xlab='')
        lines(ftr*dnorm(E, mean = pos[['c3']][2], sd = 0.08), x=E)
        axis(side=1, pos=0, lwd.ticks=0, labels=FALSE, lwd=lwd+1)
        abline(v=0.5, lty=2)
        
        # Close file
        dev.off()
        
        
        #### c4 ####
        
        # Save plot in file
        png('./manuscript/img/concept_c4.png', width = 150, height = 75, units='mm', res = 700)
        
        # Transparent backgrounf
        par(bg=NA)
        
        # plot
        plot(ftr*dnorm(E, mean = pos[['c4']][1], sd = 0.08), x=E, type='l',
             ylim=c(0,1),
             lwd=lwd, 
             yaxs="i", xaxs="i",
             axes=F,
             ylab='', xlab='')
        lines(ftr*dnorm(E, mean = pos[['c4']][2], sd = 0.08), x=E)
        axis(side=1, pos=0, lwd.ticks=0, labels=FALSE, lwd=lwd+1)
        abline(v=0.5, lty=2)
        
        # Close file
        dev.off()
}

