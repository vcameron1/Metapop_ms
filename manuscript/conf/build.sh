#!/bin/sh
###################################################################
# Bash file to build the manuscript outputs (pdf)
# Victor Cameron
# Juily 27, 2021
# Using Will Viera's bash script from: https://github.com/willvieira/ms_STM-managed/blob/master/manuscript/conf/build.sh
###################################################################

# Arguments to pass to this script:
# - $1 manuscript.md
# - $2 references.bib
# - $3 metadata.yml
# - $4 ...


###################################################################
# Steps
# - Load metada.yml
# - Build pdf
# - Build title Page (if double-blind is TRUE)
###################################################################



# Load metadata.yml using a bash script from: https://github.com/jasperes/bash-yaml
curl -s https://raw.githubusercontent.com/jasperes/bash-yaml/master/script/yaml.sh -o load_yaml.sh
source load_yaml.sh
create_variables $3
rm load_yaml.sh


# Folder to save manuscript outputs
mkdir docs


# Build pdf
echo [1] Rendering manuscript pdf
pandoc $1 -o docs/manuscript.pdf \
    --pdf-engine=xelatex \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2

# if double-blind, print title page separated
if ${double_blind}
then
    echo [1] Rendering title page pdf
    pandoc $1 -o docs/manuscript_title.pdf \
        --metadata-file=$3 \
        --template=manuscript/conf/templateTitle.tex
fi

# Build tex
echo [1] Rendering manuscript tex
pandoc $1 -o docs/manuscript.tex \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2

# Build html
echo [1] Rendering html document
pandoc -s --mathjax \
    -f markdown -t html \
    $1 -o docs/manuscript.html \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.html \
    --filter pandoc-xnos \
    --toc \
    --bibliography=$2