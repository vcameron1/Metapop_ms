# Manuscript
	msOutput=docs/manuscript.pdf
	msInput=manuscript/manuscript.md
	CONF=manuscript/conf/*
	BIB=manuscript/references.bib
	META=metadata.yml

# R
	bibR=R/update_bib.R

# render manuscript pdf
$(msOutput): $(META) $(BIB) $(CONF)
	@sh manuscript/conf/build.sh $(msInput) $(BIB) $(META)

# generate bib file
$(BIB): $(msInput) $(bibR)
	@echo [1] check if references are up to date
	@Rscript -e "source('$(bibR)')"

# install dependencies
install:
	Rscript -e 'if (!require(rootSolve)) install.packages("rootSolve"); if (!require(stringr)) install.packages("stringr"); if (!require(RefManageR)) install.packages("RefManageR")'

clean: check_clean
	rm $(PDF)

check_clean:
	@echo -n "Are you sure you want to delete all figures and the associated data? [y/N] " && read ans && [ $${ans:-N} == y ]

.PHONY: install clean check_clean