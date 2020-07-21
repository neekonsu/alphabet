#!/bin/sh

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${0%.*}")
INPUTDIRECTORY="dirname $0"
# Input bam file for MACS2
# ex: (./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam)
INPUTBAM=$1
# Output directory for MACS2, input for bedtools
# ex: (./example_chr22/ABC_output)
OUTPUTDIRECTORY=$2
# Directory of reference chromosome, located inside ABC git repo
# ex: (./example_chr22/reference/chr22)
REFERENCECHROMOSOMEDIRECTORY=$3
# Directory of all python scripts/sourcecode in ABC git repo
# ex: (./src)
ABCREPOSITORYSRCDIRECTORY=$4
# Filename of reference sequence curated w/o file extension
# ex: (RefSeqCurated.170308.bed.CollapsedGeneBounds)
REFERENCESEQUENCEBED=$5
# Filename input BAM file for run.neighborhoods.py
# ex: (ENCFF384ZZM.chr22.bam)
INPUTBAMFORNEIGHBORHOODS=$7
# Filename of Expression Table txt file
# ex: (K562.ENCFF934YBO.TPM.txt)
EXPRESSIONTABLETXT=$8
# Filename of Ubiquitously Expressed Genes txt file
# ex: (UbiquitouslyExpressedGenesHG19.txt)
UBIQUITOUSLYEXPRESSEDGENESTXT=$9
# Celltype identifier (string)
# ex: (K562)
CELLTYPEIDENTIFIER=${10}
# HiC resolution argument
# ex: (5000)
HICRESOLUTION=${11}

WD=${12}
cd $WD

python3 -m venv env
source env/bin/activate
python3 $ABCREPOSITORYSRCDIRECTORY/predict.py \
        --enhancers $OUTPUTDIRECTORY/Neighborhoods/EnhancerList.txt \
        --genes $OUTPUTDIRECTORY/Neighborhoods/GeneList.txt \
        --HiCdir $INPUTBAM/HiC/raw/ \
        --hic_resolution $HICRESOLUTION \
        --scale_hic_using_powerlaw \
        --threshold .02 \
        --cellType $CELLTYPEIDENTIFIER \
        --outdir $OUTPUTDIRECTORY/Predictions/ \
        --make_all_putative
deactivate