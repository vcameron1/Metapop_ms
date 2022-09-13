# Conceptual figures

The scripts in this folder contain the code to plot conceptual figures and assemble them into pannels for the manuscript

## Conceptual figures of the manuscript
---
### Figure 1
Title : Basic representation of the effect of H and e/c interaction on determining the occupancy.

Script : intro_persistence_fig.R

Command : 
```r
source("./conceptual_fig/intro_persistence_fig.R")
intro_persistence_plot()
```

Description : Introduction to interaction of H and e/c on species occupancy and persistence.

### Figure 2
Title : Conceptual exploration of the interaction effect of H and e/c on occupancy

Script : persistence_fig.R

Command :
```r
source("./conceptual_fig/concept_occ.R")
```

Description : Three panels figure

### Figure 3
Title :

Script :

Command:
```r
metapopEffect_plot()
```

Description :

### Figure 4
Title :

Script :

Description :

### Figure 5
Title : Conceptual representation of landscape-scale effects of climate change on persistence

Script : concept_landscape_fig.R

Command :
```r
source("./conceptual_fig/concept_landscape_fig.R")
concept_land_fig()
```

Description : Cartoon of a landscape using a graph representation of linked patches representing habitat patches and dispersal. The complex effects of landscape-scale changes to distribution by climate changes are visually demonstrated in this figure.

## Contents
---

### plot_image.R 
Function to add image to plot