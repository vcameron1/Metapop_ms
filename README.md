# Paper: Spatial Structure is More Than Habitat Amount: A Metapopulation Approach is Necessary to Project Distributions Under Climate Change

[![Build and deploy](https://github.com/vcameron1/Metapop_ms/actions/workflows/build.yml/badge.svg)](https://github.com/vcameron1/Metapop_ms/actions/workflows/build.yml) [![html](https://img.shields.io/badge/read-html-brightgreen)](https://vcameron1.github.io/Metapop_ms/) [![pdf](https://img.shields.io/badge/read-pdf-green.svg)](https://vcameron1.github.io/Metapop_ms/manuscript.pdf) [![pdf](https://img.shields.io/badge/read-docx-yellow.svg)](https://vcameron1.github.io/Metapop_ms/manuscript.docx)

A compendium of data, code, analysis and author's manuscript accompanying the publication.

Our study discusses the limitations of climate suitability models in projecting species distributions under climate change. It proposes the use of metapopulation theory to enhance species distribution models by considering factors such as biotic interactions, demography, and landscape structure. We explores three key concepts: non-equilibrium dynamics due to habitat-climate mismatch, nonlinear distribution change from linear habitat occupancy change, and counterintuitive effects of environmental change on higher trophic levels. We illustrate these concepts through a case study of Bicknell's Thrush, a threatened bird, showing that climate-induced habitat changes impact patch structure and connectivity, influencing species persistence. The findings emphasize the importance of integrating habitat amount and spatial structure in assessing species distribution changes under climate change.

The template used is freely adapted from Will Vieira' work at [https://github.com/willvieira/ms_STM-managed](https://github.com/willvieira/ms_STM-managed).


## Contents of the repository

The repository is structured as follows:

```
.
├── LICENSE
├── README.md
├── metadata.yml
├── makefile
├── data_clean
├── manuscript
│   ├── manuscript.md
│   ├── references.bib
│   ├── conf
│       ├── build.sh
│       ├── ecology.csl
│       ├── template.tex
│       ├── template.html
│       ├── template.docx
│       ├── templateTitle.tex
│       └── templateWord.tex
│   └── img
├── R
├── conceptual_fig
├── SDM
    ├── 01_prepare_data.R
    ├── 02_GRBI_SDM.R
    ├── 03_projections.R
    ├── XX_compress_data.R
    ├── SDM_functions.R
    ├── patch_metrics_functions.R
    ├── vif.R
    └── results
        ├── BITH_RCP45_2020.tif
        ├── BITH_RCP45_2040.tif
        ├── BITH_RCP45_2070.tif
        ├── BITH_RCP45_2100.tif
        ├── BITH_biomass_2020.tif
        ├── BITH_biomass_2040.tif
        ├── BITH_biomass_2070.tif
        └── BITH_biomass_2100.tif
```

**metadata.yml**

This file contains the metadata of the manuscript, including the authors, the license, the abstract and the various statements.

**makefile**

This file contains the instructions to build the manuscript and the figures. The file is used by the `make` command to build the manuscript and the figures.

**data_clean/**

This folder contains the rasterized (cleaned and formated) Bicknell's thrush observation data.

**manuscript/**

This folder contains the manuscript in markdown format, the bibliography, the templates to build the html, pdf and Word versions, and the figures.

**R/**

This folder contains the scripts to download the results and build the result figures.

**conceptual_fig/**

The scripts in this folder contain the code to plot conceptual figures and assemble them into panels for the manuscript.

**SDM/**

This folder contains the scripts to run the Species Distribution Model (SDM) and execute the projections. Scripts prepare the model's data, run the SDM, project the SDM into the scenarios and computes the result metrics. The folder also contains in `SDM/results/` the results of the SDM and the projections.

## Data

The data that support the study are available from the Regroupement QuébecOiseaux (RQO), McKenney et al. (2013) and Boulanger and Pascual Puigdevall (2021). RQO data contains observations from various sources, including scientific surveys and citizen science and restrictions apply to the availability of RQO data, which were used under license for the current study, and so are not publicly available. Data are, however, available from the authors upon reasonable request and with written permission of RQO. Data from Boulanger and Pascual Puigdevall (2021) are available from its authors upon request.


## How to execute the analyses

Assuming that the user has the raw data from RQO and Boulanger and Pascual Puigdevall (2021) saved in the `data_raw` subdirectory, the analyses can be executed by running the following command in a terminal:

```bash
# Install the dependencies
#renv::restore()

make -C SDM
```


## How to build the manuscript

The manuscript can be built from the results by running the following command in a terminal:

```bash
make
```

## License

Spatial Structure is More Than Habitat Amount: A Metapopulation Approach is Necessary to Project Distributions Under Climate Change © 2024 by Victor Cameron, F. Guillaume Blanchet, Yan Boulanger, Junior Tremblay, Dominique Gravel is licensed under CC BY 4.0. To view a copy of this license, visit [http://creativecommons.org/licenses/by/4.0/](http://creativecommons.org/licenses/by/4.0/).