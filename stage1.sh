#!/bin/sh

# Base filename for the input bam file it MACS2 (sliced extension)
# TODO: isolate filename from directory; right now this is the whole directory.
# When used in conjunction with other variables, we get impossible addresses;
# `Error: The requested file (./example_chr22/ABC_output/Peaks/./stage.macs2_peaks.narrowPeak) could not be opened.`
INPUT="${0::-4}"
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
bedtools sort -faidx $REFERENCECHROMOSOMEDIRECTORY/chr22 \
    -i $OUTPUTDIRECTORY/$INPUT.macs2_peaks.narrowPeak 
    > $OUTPUTDIRECTORY/$INPUT.macs2_peaks.narrowPeak.sorted

# Define candidate regions using output of sorted ^narrowPeaks^
# May need to change virtual environments here
# `nStrongestPeaks` needs calibration. Read ABC documentation for commentary.
python $ABCREPOSITORYPYTHONDIRECTORY/makeCandidateRegions.py \
    --narrowPeak $OUTPUTDIRECTORY/$INPUT.macs2_peaks.narrowPeak.sorted \
    --bam $INPUTBAM \
    --outDir $OUTPUTDIRECTORY/ \
    --chrom_sizes $REFERENCECHROMOSOMEDIRECTORY/chr22 \
    --regions_blacklist $ABCREPOSITORYPYTHONDIRECTORY/../wgEncodeHg19ConsensusSignalArtifactRegions.bed \
    --regions_whitelist $REFERENCECHROMOSOMEDIRECTORY/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000