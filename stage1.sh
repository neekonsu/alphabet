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

# Confirming that arguments are passed correctly between go and shell through printout
echo "——————————————————————"
echo "Confirming arguments:"
echo "1: $1\n2: $2\n3: $3\n4: $4\n5: $5\n6: $6\n7: $7\n8: $8\n9: $9\n10: ${10}\n11: ${11}\n12: ${12}"
echo "——————————————————————"
echo "Wait 3 seconds . . . "
sleep 3
echo "Setting working directory to ${12}"
cd "${12}"

# Call peaks on a DNase-seq or ATAC-seq bam file using MACS2
echo "Verifying arguments for 'macs2 callpeak'"
echo "——————————————————————"
echo "${INPUTBAM}"
echo "example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam"
echo "——————————————————————"
echo "${INPUTFILENAME}.chr22.macs2"
echo "wgEncodeUwDnaseK562AlnRep1.chr22.macs2"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/"
echo "example_chr22/ABC_output/Peaks/"
echo "——————————————————————"
macs2 callpeak \
    -t "${INPUTBAM}" \
    -n "${INPUTFILENAME}.chr22.macs2" \
    -f BAM \
    -g hs \
    -p .1 \
    --call-summits \
    --outdir "${OUTPUTDIRECTORY}/Peaks/"

# Sort narrowPeak file using bedtools
echo "Verifying arguments for 'bedtools sort -faidx'"
echo "——————————————————————"
echo "${REFERENCECHROMOSOMEDIRECTORY}/chr22"
echo "example_chr22/reference/chr22"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak"
echo "example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted"
echo "example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted"
echo "——————————————————————"
bedtools sort -faidx "${REFERENCECHROMOSOMEDIRECTORY}/chr22" \
    -i "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak" 
    > "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted"

# Define candidate regions using output of sorted ^narrowPeaks^
# May need to change virtual environments here
# `nStrongestPeaks` needs calibration. Read ABC documentation for commentary.
echo "Verifying arguments for 'makeCandidateRegions.py'"
echo "——————————————————————"
echo "${ABCREPOSITORYSRCDIRECTORY}/makeCandidateRegions.py"
echo "src/makeCandidateRegions.py"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted"
echo "example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted"
echo "——————————————————————"
echo "${INPUTBAM}"
echo "example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/"
echo "example_chr22/ABC_output/Peaks/"
echo "——————————————————————"
echo "${REFERENCECHROMOSOMEDIRECTORY}/chr22"
echo "example_chr22/reference/chr22"
echo "——————————————————————"
echo "./reference/${CONSENSUSSIGNALARTIFACTFILENAME}"
echo "reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed"
echo "——————————————————————"
echo "$(REFERENCECHROMOSOMEDIRECTORY)/${REFERENCESEQUENCEBED}.TSS500bp.chr22.bed"
echo "example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed"
echo "——————————————————————"
python3 "${ABCREPOSITORYSRCDIRECTORY}/makeCandidateRegions.py" \
    --narrowPeak "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted" \
    --bam "${INPUTBAM}" \
    --outDir "${OUTPUTDIRECTORY}/Peaks/" \
    --chrom_sizes "${REFERENCECHROMOSOMEDIRECTORY}/chr22" \
    --regions_blacklist "./reference/${CONSENSUSSIGNALARTIFACTFILENAME}" \
    --regions_whitelist "$(REFERENCECHROMOSOMEDIRECTORY)/${REFERENCESEQUENCEBED}.TSS500bp.chr22.bed" \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000