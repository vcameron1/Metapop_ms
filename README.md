# Paper: SPATIAL STRUCTURE IS MORE THAN HABITAT AMOUNT: A METAPOPULATION APPROACH IS NECESSARY TO PROJECT DISTRIBUTIONS UNDER CLIMATE CHANGE

[![Build and deploy](https://github.com/vcameron1/Metapop_ms/actions/workflows/build.yml/badge.svg)](https://github.com/vcameron1/Metapop_ms/actions/workflows/build.yml) [![html](https://img.shields.io/badge/read-html-brightgreen)](https://vcameron1.github.io/Metapop_ms/) [![pdf](https://img.shields.io/badge/read-pdf-green.svg)](https://vcameron1.github.io/Metapop_ms/manuscript.pdf) [![pdf](https://img.shields.io/badge/read-docx-yellow.svg)](https://vcameron1.github.io/Metapop_ms/manuscript.docx)

A compendium of data, code, analysis and author's manuscript accompanying the publication.

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
│   └── 06_clean_GRBI.R
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
    ├── model_selection.R
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

This folder contains the script to clean and rasterize the Bicknel's thrush observation data.

**manuscript/**

This folder contains the manuscript in markdown format, the bibliography, the templates to build the html, pdf and Word versions, and the figures.

**R/**

This folder contains the scripts to download the results and build the result figures.

**conceptual_fig/**

The scripts in this folder contain the code to plot conceptual figures and assemble them into pannels for the manuscript.

**SDM/**

This folder contains the scripts to run the Species Distribution Model (SDM) and execute the projections. Script prepare the model's covariables, run the SDM, project the SDM into the future and computes the result metrics. The folder also contains in `SDM/results/` the results of the SDM and the projections.

### Data

The data that support the study are available from the Regroupement QuébecOiseaux (RQO), McKenney et al. (2013) and Boulanger and Pascual Puigdevall (2021). RQO data contains observations from various sources, including scientific surveys and citizen science and restrictions apply to the availability of RQO data, which were used under license for the current study, and so are not publicly available. Data are, however, available from the authors upon reasonable request and with written permission of RQO. Data from Boulanger and Pascual Puigdevall (2021) are available from its authors upon request.


## Execute the analyses

Assuming that the user has the raw data from RQO and Boulanger and Pascual Puigdevall (2021) saved in the `data_raw` subdirectory, the analyses can be executed by running the following commands in a R session :

```
# Install the dependencies
#renv::restore()

# 01 prepare Bicknell's thrush observation data for analysis
source("data_clean/06_clean_GRBI.R")

# 02 prepare the covariables for the SDM
source("SDM/01_prepare_data.R")

# 03 run the SDM
source("SDM/02_GRBI_SDM.R")

# 04 project the SDM into the future
source("SDM/03_projections.R")
```


## How to build the manuscript

The manuscript can be built from the results by running the following command in the terminal :

```
make
```