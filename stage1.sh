#!/bin/sh

# TODO: Provide example path/filename in each comment of each variable
# TODO: attempt to eliminate more static paths by creating new variables

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${1%.*}")
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
# Filename Consensus Signal Artifact
# ex: (wgEncodeHg19ConsensusSignalArtifactRegions.bed)
CONSENSUSSIGNALARTIFACTFILENAME=$6

WD=${12}

# Confirming that arguments are passed correctly between go and shell through printout
echo "——————————————————————" >&2
echo "Confirming arguments:" >&2
echo "1: $1\n2: $2\n3: $3\n4: $4\n5: $5\n6: $6\n7: $7\n8: $8\n9: $9\n10: ${10}\n11: ${11}\n12: ${12}" >&2
echo "——————————————————————" >&2
echo "Wait 3 seconds . . . "
sleep 3
echo "Setting working directory to ${12}"
cd $WD
pwd

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