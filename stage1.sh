#!/bin/sh

# TODO: Provide example path/filename in each comment of each variable
# TODO: attempt to eliminate more static paths by creating new variables

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${0%.*}")
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
# Filename Consensus Signal Artifact
# ex: (wgEncodeHg19ConsensusSignalArtifactRegions.bed)
CONSENSUSSIGNALARTIFACTFILENAME=$5

# Confirming that arguments are passed correctly between go and shell through printout
echo "Confirming arguments:" >&2
echo "0: $0, 1: $1, 2: $2, 3: $3, 4: $4, 5: $5, 6: $6, 7: $7, 8: $8, 9: $9" >&2
echo "Wait 3 seconds . . . "
sleep 3

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
python $ABCREPOSITORYSRCDIRECTORY/makeCandidateRegions.py \
    --narrowPeak $OUTPUTDIRECTORY/$INPUTFILENAME.macs2_peaks.narrowPeak.sorted \
    --bam $INPUTBAM \
    --outDir $OUTPUTDIRECTORY/Peaks/ \
    --chrom_sizes $REFERENCECHROMOSOMEDIRECTORY/chr22 \
    --regions_blacklist $ABCREPOSITORYSRCDIRECTORY/../reference/$CONSENSUSSIGNALARTIFACTFILENAME \
    --regions_whitelist $REFERENCECHROMOSOMEDIRECTORY/$REFERENCESEQUENCEBED.TSS500bp.chr22.bed \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000