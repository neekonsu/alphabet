#!/bin/sh

# TODO: Provide example path/filename in each comment of each variable
# TODO: attempt to eliminate more static paths by creating new variables

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${0%.*}")
INPUTDIRECTORY="dirname $0"
# Input bam file for MACS2
INPUTBAM=$0
# Output filename for MACS2 file
OUTPUTMACS2=$1
# Output directory for MACS2, input for bedtools
OUTPUTDIRECTORY=$2
# Directory of reference chromosome, located inside ABC git repo (example_chr22/reference/chr22)
REFERENCECHROMOSOMEDIRECTORY=$3
# Directory of all python scripts/sourcecode in ABC git repo (src/*.py)
ABCREPOSITORYPYTHONDIRECTORY=$4
# Filename input BAM file for run.neighborhoods.py
INPUTBAMFORNEIGHBORHOODS=$5
# Filename of reference sequence curated (BED)
REFERENCESEQUENCEBED=$6
# Filename of Expression Table txt file
EXPRESSIONTABLETXT=$7
# Filename of Ubiquitously Expressed Genes txt file
UBIQUITOUSLYEXPRESSEDGENESTXT=$8

#Input DNase-Seq/ATAC-Seq & H3K27ac ChIP-Seq reads to 'run.neighborhoods.py'; following is example command:
python $ABCREPOSITORYPYTHONDIRECTORY/run.neighborhoods.py \
        --candidate_enhancer_regions $OUTPUTDIRECTORY/Peaks/$INPUTFILENAME.macs2_peaks.narrowPeak.sorted.candidateRegions.bed \
        --genes $REFERENCECHROMOSOMEDIRECTORY/$REFERENCESEQUENCEBED \
        --H3K27ac $INPUTDIRECTORY/Chromatin/$INPUTBAMFORNEIGHBORHOODS \
        --DHS $INPUTDIRECTORY/Chromatin/$INPUTFILENAME.chr22.bam,$INPUTDIRECTORY/Chromatin/${INPUTFILENAME%?}2.chr22.bam \
        --expression_table $INPUTDIRECTORY/Expression/$EXPRESSIONTABLETXT \
        --chrom_sizes $REFERENCECHROMOSOMEDIRECTORY/chr22 \
        --ubiquitously_expressed_genes $ABCREPOSITORYPYTHONDIRECTORY/../reference/$UBIQUITOUSLYEXPRESSEDGENESTXT \
        --cellType K562 \
        --outdir $OUTPUTDIRECTORY/Neighborhoods/