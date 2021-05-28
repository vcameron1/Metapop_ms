#### 
# title: Environmental correlation between trophic levels conceptual figure
# author: Victor Cameron
# date: 26/05/2021
####

# Dependencies
library(ggplot2)
source('2spMetapop_model.R')

# Parameters
lwd = 4

# Save plot in file
png('../manuscript/img/concept_CorrTrophLvls.png', width = 150, height = 150, units='mm', res = 700)

# Envrionmental gradient
seq <- seq(0, 1, by=0.025)

# Init data frame
occupancy_df<- data.frame(resource=rep(seq, time=length(seq)), consumer=rep(seq, each=length(seq)), deltaOcc=0)

# Compute prevalences
for(resource in occupancy_df$resource){
  for(consumer in occupancy_df$consumer){
    occ1 <- consumerOcc(resOpt=resource, consOpt=consumer, E=0.5) 
    occ2 <- consumerOcc(resOpt=resource, consOpt=consumer, E=0.6)
    occupancy_df[occupancy_df$consumer==consumer & occupancy_df$resource==resource,'deltaOcc'] <- occ2 - occ1
  }
}

# Plot
ggplot(occupancy_df, aes(resource, consumer, fill= deltaOcc)) + 
  xlab('Resource environmental optimum')+
  ylab('Consumer environmental optimum')+
  geom_tile() +
  colorspace::scale_fill_continuous_diverging(p1=0.8, p2=1, l1=0.4) +
  coord_fixed(expand = c(0, 0)) +
  theme(axis.title=element_text(size=20),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=lwd)) +
  geom_abline(linetype = "dashed") +
  geom_vline(xintercept = 0.5) +
  geom_hline(yintercept = 0.5)

# Close file
dev.off()
