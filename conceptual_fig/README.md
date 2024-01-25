# Conceptual figures

The scripts in this folder contain the code to plot conceptual figures and assemble them into pannels for the manuscript

## Conceptual figures of the manuscript
---
### Figure 1
Title:Graphical representation of range limits

Script: `intro_persistence_fig.R`

Command: 
```r
source("./conceptual_fig/intro_persistence_fig.R")
intro_persistence_plot()
```

Description: Graphical interpretation of the system’s distribution dynamics. The distribution of the habitat specialist is defined by its intrinsic response to the environment $\frac{e}{c}$ (orange line) and by habitat occupancy ($H(E)$, green line). The habitat specialist’s occupancy $S^{*}$ declines with less favourable environmental conditions $E_{0}^{*}$ and $E_{1}^{*}$

### Figure 2
Title: Interaction of the specialist and of its habitat’s response can cause indirect distribution dynamics

Script: `concept_occ_fig.R`

Command:
```r
source("./conceptual_fig/concept_occ_fig.R")
```

Description: Change in occupancy (and persistence as shown by the grey arrows) of the habitat specialist depends on its intrinsic response to the environment $\frac{e}{c}$ (orange line) and of the habitat’s response $H(E^{*})$ (green line)

### Figure 3
Title: Habitat mismatch affects species distribution shifts

Script: `mismatch_fig.R`

Command:
```r
source("./conceptual_fig/mismatch_fig.R")
mismatch_plot()
```

Description: The distribution of the habitat specialist (grey area) is impacted by the functions relating the intrinsic response to the environment (orange line) to habitat occupancy ($H(E)$, full and dashed green lines)

### Figure 4
Title: Metapopulation dynamics may precipitate species decline

Script: `metapopEffect_fig.R`

Command:
```r
source("./conceptual_fig/metapopEffect_fig.R")
metapopEffect_plot()
```

Description: The response of a habitat specialist to a linear environmental change in time as it would be expected with a correlative SDM (linear response; full line). Metapopulation dynamics may precipitate - or alternatively delay - the extinction of the species in a metapopulation even if there are suitable conditions (dashed line)

### Figure 5
Title: Conceptual representation of landscape-scale effects of climate change on persistence

Script: `concept_landscape_fig.R`

Command:
```r
source("./conceptual_fig/concept_landscape_fig.R")
landscape <- get_land()
concept_land_fig(patches = landscape[c(1,2)], r = landscape$r)
```

```r
# Compute metapopulation metrics
source("./conceptual_fig/patchArea_metrics.R")
metrics <- patch_area_metrics(patches = landscape[c(1,2)], r = landscape$r)
```

Description: Species persistence is affected by changes to landscape connectivity as well as habitat amount. Black circles filled in grey delimit suitable habitat patches. The left panel presents a hypothetical mountainous landscape where suitable patches represent high elevation mountain tops and right panel the same landscape where patches contracted by an equal amount, simulating an elevation shift of climatic conditions on landscape suitability. Following patch contraction, metapopulation capacity declined by 82% whereas habitat amount only declined by 63%


## Other scripts

### plot_image

Script : `plot_image.R`

Description: Function to add image to plot

### patchArea_metrics

Script : `patchArea_metrics.R`

Description: Function to compute metapopulation metrics

### 2spMetapop_model

Script : `2spMetapop_model.R`

Description: Function to simulate metapopulation dynamics