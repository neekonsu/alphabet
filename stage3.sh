#!/bin/sh

# Input bam file for MACS2
# ex: (./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam)
INPUTBAM=$1
# Output directory for MACS2, input for bedtools
# ex: (./example_chr22/ABC_output)
OUTPUTDIRECTORY=$2
# Directory of all python scripts/sourcecode in ABC git repo
# ex: (./src)
ABCREPOSITORYSRCDIRECTORY=$4
# Celltype identifier (string)
# ex: (K562)
CELLTYPEIDENTIFIER=${10}
# HiC resolution argument
# ex: (5000)
HICRESOLUTION=${11}

WD=${12}
cd $WD

echo "Verifying arguments for run.neighborhoods.py"
echo "——————————————————————"
echo "${ABCREPOSITORYSRCDIRECTORY}/predict.py"
echo "src/predict.py"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Neighborhoods/EnhancerList.txt"
echo "example_chr22/ABC_output/Neighborhoods/EnhancerList.txt"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Neighborhoods/GeneList.txt"
echo "example_chr22/ABC_output/Neighborhoods/GeneList.txt"
echo "——————————————————————"
echo "${INPUTBAM}/HiC/raw/"
echo "example_chr22/input_data/HiC/raw/"
echo "——————————————————————"
echo "${HICRESOLUTION}"
echo "5000"
echo "——————————————————————"
echo "${CELLTYPEIDENTIFIER}"
echo "K562"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Predictions/"
echo "example_chr22/ABC_output/Predictions/"
echo "——————————————————————"
python3 "${ABCREPOSITORYSRCDIRECTORY}/predict.py" \
        --enhancers "${OUTPUTDIRECTORY}/Neighborhoods/EnhancerList.txt" \
        --genes "${OUTPUTDIRECTORY}/Neighborhoods/GeneList.txt" \
        --HiCdir "${INPUTBAM}/HiC/raw/" \
        --hic_resolution "${HICRESOLUTION}" \
        --scale_hic_using_powerlaw \
        --threshold .02 \
        --cellType "${CELLTYPEIDENTIFIER}" \
        --outdir "${OUTPUTDIRECTORY}/Predictions/" \
        --make_all_putative