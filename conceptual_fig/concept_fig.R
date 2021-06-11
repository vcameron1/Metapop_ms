
# Dependencies
source('./conceptual_fig/CorrTrophLvls_fig.R')
source('./conceptual_fig/metapopEffect_fig.R')
source('./conceptual_fig/mismatch_fig.R')

# Generate plots
mismatch_plot()
metapopEffect_plot()
CorrTroph_plot()


# Save plot in file
png('./manuscript/img/concept.png', width = 500, height = 150, units='mm', res = 700)

par(fig=c(0,0.31,0,1))
plotimage(file = "./manuscript/img/concept_mismatch.png", size = 1, add = F, bg = "white")
mtext("A)", adj=0, line=-1.5, cex=1.5)
par(fig=c(0.31,0.62,0,1), new=TRUE)
plotimage(file = "./manuscript/img/concept_metapopEffect.png", size = 1, add = T, bg = "white")
mtext("B)", adj=0, line=-1.5, cex=1.5)
par(fig=c(0.62,0.92,0,1), new=TRUE)
plotimage(file = "./manuscript/img/concept_CorrTrophLvls.png", size = 1, add = T, bg = "white")
mtext("C)", adj=0, line=-1.5, cex=1.5)
par(fig=c(0.90,0.97,0,1),new=TRUE)
plotimage(file = "./manuscript/img/concept_ColorScale.png", size = 1, add = T, bg = "white")

# Close file
dev.off()

# Remove temporary plots
file.remove("./manuscript/img/concept_mismatch.png")
file.remove("./manuscript/img/concept_metapopEffect.png")
file.remove("./manuscript/img/concept_CorrTrophLvls.png")
file.remove("./manuscript/img/concept_ColorScale.png")
file.remove("./manuscript/img/concept_c1.png")
file.remove("./manuscript/img/concept_c2.png")
file.remove("./manuscript/img/concept_c3.png")
file.remove("./manuscript/img/concept_c4.png")