# Scripts
	prep_data=SDM/01_prepare_data.R
	run_model=SDM/02_GRBI_SDM.R
	project_model=SDM/03_projections.R


# 01 - Prepare data
prep_data:
	@echo [1] preparing data...
	@Rscript -e "source('$(prep_data)')"

# 02 - Run model
run_model:
	@echo [1] building BITH's distribution model...
	@Rscript -e "source('$(run_model)')"

# 03 - project model
project_model:
	@echo [1] projecting BITH's distribution...
	@Rscript -e "source('$(project_model)')"
	@echo [1] done!
	@echo [1] results are in SDM/results


# install dependencies
install:
	Rscript -e 'if (!require(raster)) install.packages("raster"); if (!require(sf)) install.packages("sf"); if (!require(sp)) install.packages("sp"); if (!require(readxl)) install.packages("readxl")'