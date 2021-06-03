
# Save plot in file
png('./manuscript/img/concept.png', width = 450, height = 150, units='mm', res = 700)


layout(matrix(c(1,2,3), nrow=1, ncol=3), widths=c(5,5,5), heights=5)
#layout.show(3)

plotimage(file = "./manuscript/img/concept_mismatch.png", size = 1, add = F, bg = "white")
mtext("A)", adj=0, line=-1.5, cex=1.5)
plotimage(file = "./manuscript/img/concept_metapopEffect.png", size = 1, add = F, bg = "white")
mtext("B)", adj=0, line=-1.5, cex=1.5)
plotimage(file = "./manuscript/img/concept_CorrTrophLvls.png", size = 1, add = F, bg = "white")
mtext("C)", adj=0, line=-1.5, cex=1.5)

dev.off()


