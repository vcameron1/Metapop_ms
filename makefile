# Manuscript
	msOutput=docs/manuscript.pdf docs/manuscript.html docs/manuscript.docx
	msInput=manuscript/manuscript.md
	CONF=manuscript/conf/*
	BIB=manuscript/references.bib
	META=metadata.yml

# Conceptual figures
	# Introduction to persistence
	fig1R=conceptual_fig/intro_persistence_fig.R
	fig1=manuscript/img/intro_persistence.png
	# Occurence
	fig2R=conceptual_fig/concept_occ_fig.R
	fig2=manuscript/img/concept_occ.png
	# Mismatch
	fig3R=conceptual_fig/mismatch_fig.R
	fig3=manuscript/img/concept_mismatch.png
	# Metapop effect
	fig4R=conceptual_fig/metapopEffect_fig.R
	fig4=manuscript/img/concept_metapopEffect.png
	# Metapop spatial structure
	fig5R=conceptual_fig/concept_landscape_fig.R
	fig5=manuscript/img/concept_metapop_structure.png

# Result figures
	# BITH projected maps
	fig6R=R/map_BITH_projections.R
	fig6=manuscript/img/map_BITH.png
	# Spatial configuration
	fig7R=R/plot_spatial_configuration.R
	fig7=manuscript/img/spatial_configuration.png
	# Persistence
	fig8R=R/plot_persistence.R
	fig8DATA=SDM/results/BITH_metrics_QC.RDS
	fig8=manuscript/img/capacity.png

# Results
	RES=SDM/results/BITH_metrics_QC.RDS
	resR=R/get_results_file.R
	# source("./SDM/patch_metrics_functions.R")


# R
	bibR=R/update_bib.R


# Analyses
sdm: $(RES)
	MAKE -C SDM

# render manuscript
$(msOutput): $(META) $(BIB) $(CONF) $(fig1) $(fig2) $(fig3) $(fig4) $(fig5) $(fig6) $(fig7) $(fig8) $(RES)
	@bash manuscript/conf/build.sh $(msInput) $(BIB) $(META)

# generate bib file
$(BIB): $(msInput) $(bibR)
	@echo [1] check if references are up to date
	@Rscript -e "source('$(bibR)')"

# get results
$(RES): $(resR)
	@echo [1] getting results
	@Rscript -e "source('$(resR)')";

# plot figure 1
$(fig1): $(fig1R)
	@Rscript -e "source('./conceptual_fig/intro_persistence_fig.R'); intro_persistence_plot()"

# plot figure 2
$(fig2): $(fig2R)
	@Rscript -e "source('./conceptual_fig/concept_occ.R'); concept_occ_plot()"

# plot figure 3
$(fig3): $(fig3R)
	@Rscript -e "source('./conceptual_fig/concept_mismatch.R'); concept_mismatch_plot()"

# plot figure 4
$(fig4): $(fig4R)
	@Rscript -e "source('./conceptual_fig/metapopEffect.R'); metapopEffect_plot()"

# plot figure 5
$(fig5): $(fig5R)
	@Rscript -e "source('./conceptual_fig/concept_landscape_fig.R'); landscape <- get_land(); concept_land_fig(patches = landscape[c(1,2)], r = landscape$r)"

# plot figure 6
$(fig6): $(fig6R)
	@Rscript -e "source('R/map_BITH_projections.R')"

# plot figure 7
$(fig7): $(fig7R) $(RES)
	@Rscript -e "source('R/plot_spatial_configuration.R')"

# plot figure 8
$(fig8): $(fig8R) $(RES)
	@Rscript -e "source('R/plot_persistence.R')"

# install dependencies
install:
	Rscript -e 'if (!require(rootSolve)) install.packages("rootSolve"); if (!require(stringr)) install.packages("stringr"); if (!require(RefManageR)) install.packages("RefManageR")'

clean: check_clean
	rm $(PDF)

check_clean:
	@echo -n "Are you sure you want to delete all figures and the associated data? [y/N] " && read ans && [ $${ans:-N} == y ]

.PHONY: install clean check_clean
