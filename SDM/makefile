# Scripts
prep_data=01_prepare_data.R
run_model=02_GRBI_SDM.R
project_model=03_projections.R

# Data
template=../data_raw/RCP45_GrowthBudwormBaselineFire_ABIE.BAL_0_merged.RData
BITH_RAW="../data_raw/RAPPORT QO_SOS-POP SCF_GRBI.xlsx"

# 01 - Prepare data
prep_data: $(template) 
	@echo [1] preparing data...
	@Rscript -e "source('$(prep_data)')"

# 02 - Run model
run_model: $(prep_data) $(run_model)
	@echo [1] building BITH's distribution model...
	@Rscript -e "source('$(run_model)')"

# 03 - project model
project_model: $(prep_data) $(run_model) $(project_model)
	@echo [1] projecting BITH's distribution...
	@Rscript -e "source('$(project_model)')"
	@echo [1] done!
	@echo [1] results are in SDM/results


# install dependencies
install:
	Rscript -e 'if (!require(raster)) install.packages("raster"); if (!require(sf)) install.packages("sf"); if (!require(sp)) install.packages("sp"); if (!require(readxl)) install.packages("readxl")'

.PHONY: all