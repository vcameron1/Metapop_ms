#!/bin/bash

#SBATCH --account=def-dgravel
#SBATCH -t 05:00:00
#SBATCH --mem=1024
#SBATCH --job-name=GRBI_SDM
#SBATCH --mail-user=victor.cameron@usherbrooke.ca
#SBATCH --mail-type=ALL

Rscript SDM/GRBI_mapSpecies.R
