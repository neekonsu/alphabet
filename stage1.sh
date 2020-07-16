#!/bin/sh

# TODO: Provide example path/filename in each comment of each variable
# TODO: attempt to eliminate more static paths by creating new variables

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${0%.*}")
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
# Filename of reference sequence curated (BED)
REFERENCESEQUENCEBED=$5
# Filename Consensus Signal Artifact
CONSENSUSSIGNALARTIFACTFILENAME=$6

# Confirming that arguments are passed correctly between go and shell through printout
echo "0: $0, 1: $1, 2: $2" >&2

# Call peaks on a DNase-seq or ATAC-seq bam file using MACS2
macs2 callpeak \
    -t $INPUTBAM \
    -n $INPUTFILENAME.chr22.macs2 \
    -f BAM \
    -g hs \
    -p .1 \
    --call-summits \
    --outdir $OUTPUTDIRECTORY/Peaks/

# Sort narrowPeak file using bedtools
bedtools sort -faidx $REFERENCECHROMOSOMEDIRECTORY/chr22 \
    -i $OUTPUTDIRECTORY/Peaks/$INPUTFILENAME.macs2_peaks.narrowPeak 
    > $OUTPUTDIRECTORY/Peaks/$INPUTFILENAME.macs2_peaks.narrowPeak.sorted

# Define candidate regions using output of sorted ^narrowPeaks^
# May need to change virtual environments here
# `nStrongestPeaks` needs calibration. Read ABC documentation for commentary.
python $ABCREPOSITORYPYTHONDIRECTORY/makeCandidateRegions.py \
    --narrowPeak $OUTPUTDIRECTORY/$INPUTFILENAME.macs2_peaks.narrowPeak.sorted \
    --bam $INPUTBAM \
    --outDir $OUTPUTDIRECTORY/Peaks/ \
    --chrom_sizes $REFERENCECHROMOSOMEDIRECTORY/chr22 \
    --regions_blacklist $ABCREPOSITORYPYTHONDIRECTORY/../reference/$CONSENSUSSIGNALARTIFACTFILENAME \
    --regions_whitelist $REFERENCECHROMOSOMEDIRECTORY/$REFERENCESEQUENCEBED \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000