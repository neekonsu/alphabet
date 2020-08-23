#!/bin/bash

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${1%.*}")
# Input bam file for MACS2
# ex: (./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam)
INPUTBAM=$1
# Output directory for MACS2, input for bedtools
# ex: (./example_chr22/ABC_output)
OUTPUTDIRECTORY=$2
# Directory of reference chromosome, located inside ABC git repo
# ex: (./example_chr22/reference)
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
echo "1: $1"
echo "2: $2"
echo "3: $3"
echo "4: $4"
echo "5: $5"
echo "6: $6"
echo "7: $7"
echo "8: $8"
echo "9: $9"
echo "10: ${10}"
echo "11: ${11}"
echo "12: ${12}"
echo "——————————————————————"
echo "Wait 3 seconds . . . "
sleep 3
echo "Setting working directory to ${12}"
cd "${12}"

#Download hic matrix file from juicebox
python ${12}/src/juicebox_dump.py \
--hic_file https://hicfiles.s3.amazonaws.com/hiseq/k562/in-situ/combined_30.hic \
--juicebox "java -jar /alphabet/juicer_tools.jar" \
--outdir ${12}/example_chr22/input_data/HiC/raw \
--chromosomes 22
#Fit HiC data to powerlaw model and extract parameters
python ${12}/src/compute_powerlaw_fit_from_hic.py \
--hicDir ${12}/example_chr22/input_data/HiC/raw \
--outDir ${12}/example_chr22/input_data/HiC/raw/powerlaw \
--maxWindow 1000000 \
--minWindow 5000 \
--resolution 5000 \
--chr 'chr22'

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
# macs2 callpeak \
#     -t "${INPUTBAM}" \
#     -n "${INPUTFILENAME}.chr22.macs2" \
#     -f BAM \
#     -g hs \
#     -p .1 \
#     --call-summits \
#     --outdir "${OUTPUTDIRECTORY}/Peaks/"

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
# bedtools sort -faidx "${REFERENCECHROMOSOMEDIRECTORY}/chr22" \
#     -i "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak" 
#     > "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted"

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
echo "${REFERENCECHROMOSOMEDIRECTORY}/${REFERENCESEQUENCEBED}.TSS500bp.chr22.bed"
echo "example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed"
echo "——————————————————————"
cd "${12}"

#######MAKE CANDIDATE REGIONS#############
# The makeCandidateRegions.py script is not working.
# I have copied the printout of what it should be executing, and
# that is commented below. I want to get makeCandidateRegions.py
# to work since it isn't clear if the printout included all of the details
# of execution. Mandatory debug
###############END NOTE###################
# python3 "${ABCREPOSITORYSRCDIRECTORY}/makeCandidateRegions.py" \
#     --narrowPeak "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted" \
#     --bam "${INPUTBAM}" \
#     --outDir "${OUTPUTDIRECTORY}/Peaks/" \
#     --chrom_sizes "${REFERENCECHROMOSOMEDIRECTORY}/chr22" \
#     --regions_blacklist "./reference/${CONSENSUSSIGNALARTIFACTFILENAME}" \
#     --regions_whitelist "${REFERENCECHROMOSOMEDIRECTORY}/${REFERENCESEQUENCEBED}.TSS500bp.chr22.bed" \
#     --peakExtendFromSummit 250 \
#     --nStrongestPeaks 3000

# echo "Executing awk"
# awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}' \
# ${REFERENCECHROMOSOMEDIRECTORY}/chr22 <(samtools view -H ${INPUTBAM} | grep SQ | cut -f 2 | cut -c 4- )  > ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed.temp_sort_order
# # awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}' ./example_chr22/reference/chr22 <(samtools view -H ./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam | grep SQ | cut -f 2 | cut -c 4- )  > ./example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted.wgEncodeUwDnaseK562AlnRep1.chr22.bam.Counts.bed.temp_sort_order
# echo "Executing bedtools sort"
# bedtools sort -faidx ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed.temp_sort_order \
# -i ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted \
# | bedtools coverage \
# -g ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed.temp_sort_order -counts -sorted -a stdin \
# -b ${INPUTBAM} \
# | awk '{print $1 "\t" $2 "\t" $3 "\t" $NF}' \
# | bedtools sort -faidx ${REFERENCECHROMOSOMEDIRECTORY}/chr22 -i stdin \
# > ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed; \
# rm ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed.temp_sort_order
# # echo "Running bamtobed"
# # bedtools bamtobed -i .${INPUTBAM} | cut -f 1-3 | bedtools intersect -wa -a stdin -b ${REFERENCESEQUENCEBED} | bedtools sort -i stdin -faidx ${REFERENCECHROMOSOMEDIRECTORY}/chr22 | bedtools coverage -g ${REFERENCECHROMOSOMEDIRECTORY}/chr22 -counts -sorted -a ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted -b stdin | awk '{print $1 "\t" $2 "\t" $3 "\t" $NF}' > ${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.${INPUTFILENAME}.bam.Counts.bed
# echo "Done sorting!"