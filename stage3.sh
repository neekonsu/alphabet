#!/bin/sh

# TODO: Make "hic_resolution" an argument, modify main/mian.go to prompt value

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${0%.*}")
INPUTDIRECTORY="dirname $0"
# Input bam file for MACS2
# ex: (./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam)
INPUTBAM=$0
# Output directory for MACS2, input for bedtools
# ex: (./example_chr22/ABC_output)
OUTPUTDIRECTORY=$1
# Directory of reference chromosome, located inside ABC git repo
# ex: (./example_chr22/reference/chr22)
REFERENCECHROMOSOMEDIRECTORY=$2
# Directory of all python scripts/sourcecode in ABC git repo
# ex: (./src)
ABCREPOSITORYSRCDIRECTORY=$3
# Filename of reference sequence curated w/o file extension
# ex: (RefSeqCurated.170308.bed.CollapsedGeneBounds)
REFERENCESEQUENCEBED=$4
# Filename input BAM file for run.neighborhoods.py
# ex: (ENCFF384ZZM.chr22.bam)
INPUTBAMFORNEIGHBORHOODS=$6
# Filename of Expression Table txt file
# ex: (K562.ENCFF934YBO.TPM.txt)
EXPRESSIONTABLETXT=$7
# Filename of Ubiquitously Expressed Genes txt file
# ex: (UbiquitouslyExpressedGenesHG19.txt)
UBIQUITOUSLYEXPRESSEDGENESTXT=$8
# Celltype identifier (string)
# ex: (K562)
CELLTYPEIDENTIFIER=$9

python $ABCREPOSITORYSRCDIRECTORY/predict.py \
        --enhancers $OUTPUTDIRECTORY/Neighborhoods/EnhancerList.txt \
        --genes $OUTPUTDIRECTORY/Neighborhoods/GeneList.txt \
        --HiCdir $INPUTBAM/HiC/raw/ \
        --hic_resolution 5000 \
        --scale_hic_using_powerlaw \
        --threshold .02 \
        --cellType K562 \
        --outdir $OUTPUTDIRECTORY/Predictions/ \
        --make_all_putative