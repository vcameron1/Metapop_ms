#!/bin/bash
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
# - $4 supplementary_material.md


###################################################################
# Steps
# - Load metada.yml
# - Build pdf
# - Build title Page (if double-blind is TRUE)
# - build tex
# - build html
# - build docx
# - Build Supplementary material pdf
###################################################################



# Load metadata.yml using a bash script from: https://github.com/jasperes/bash-yaml
curl -s https://raw.githubusercontent.com/jasperes/bash-yaml/master/script/yaml.sh -o load_yaml.sh
source load_yaml.sh
create_variables $3
rm load_yaml.sh


# Folder to save manuscript outputs
mkdir docs


# Build pdf
echo [3] Rendering manuscript pdf
pandoc $1 -o docs/manuscript.pdf \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --pdf-engine=xelatex \
    --number-sections \
    --bibliography=$2 \
    --csl=manuscript/conf/ecology.csl

# if double-blind, print title page separated
if ${double_blind}
then
    echo [4] Rendering title page pdf
    pandoc $1 -o docs/manuscript_title.pdf \
        --metadata-file=$3 \
        --template=manuscript/conf/templateTitle.tex
fi

# Build tex
echo [5] Rendering manuscript tex
pandoc $1 -o docs/manuscript.tex \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2 \
    --csl=manuscript/conf/ecology.csl

# Build html
echo [6] Rendering html document
pandoc -s --mathjax \
    -f markdown -t html \
    $1 -o docs/manuscript.html \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.html \
    --filter pandoc-xnos \
    --toc \
    --bibliography=$2

# Build docx
## This md -> tex _. word is a q&d until I create a lua filter to transform authors, afill and keywords in full text for word docx
echo [7] Rendering docx document
pandoc $1 -o manuscript.tex \
    --metadata-file=$3 \
    --template=manuscript/conf/templateWord.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2 \
    --csl=manuscript/conf/ecology.csl
pandoc -s manuscript.tex -o docs/manuscript.docx \
    --reference-doc=manuscript/conf/template.docx
	rm manuscript.tex

# Build Supplementary material pdf
echo [8] Rendering supplementary material pdf
pandoc $4 -o docs/supplementary_material_S1.pdf --quiet

# Move manuscript folder to docs so html can load figures
cp -R manuscript docs
rm docs/manuscript/*.md
rm -R docs/manuscript/conf
