#!/bin/sh

# Base filename for the input bam file it MACS2 (sliced extension)
INPUT="${$0%.*}"
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

# Confirming that arguments are passed correctly between go and shell through printout
echo "0: $0, 1: $1, 2: $2" >&2

# Call peaks on a DNase-seq or ATAC-seq bam file using MACS2
macs2 callpeak \
    -t $INPUTBAM \
    -n $OUTPUTMACS2 \
    -f BAM \
    -g hs \
    -p .1 \
    --call-summits \
    --outdir $OUTPUTDIRECTORY

# Sort narrowPeak file using bedtools
bedtools sort -faidx $REFERENCECHROMOSOMEDIRECTORY \
    -i $OUTPUTDIRECTORY/$INPUT.macs2_peaks.narrowPeak 
    > $OUTPUTDIRECTORY/$INPUT.macs2_peaks.narrowPeak.sorted

# Define candidate regions using output of sorted ^narrowPeaks^
# May need to change virtual environments here
# `nStrongestPeaks` needs calibration. Read ABC documentation for commentary.
python src/makeCandidateRegions.py \
    --narrowPeak example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted \
    --bam example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
    --outDir example_chr22/ABC_output/Peaks/ \
    --chrom_sizes example_chr22/reference/chr22 \
    --regions_blacklist reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed \
    --regions_whitelist example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000