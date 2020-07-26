#!/bin/sh

# TODO: attempt to eliminate more static paths by creating new variables

# Base filename for the input bam file it MACS2 (sliced extension)
INPUTFILENAME=$(basename "${1%.*}")
# Directory of input (chromatin) data
# ex: (./example_chr22/input_data/Chromatin)
INPUTDIRECTORY=$(dirname $1)
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

cd "${12}"

#Input DNase-Seq/ATAC-Seq & H3K27ac ChIP-Seq reads to 'run.neighborhoods.py'; following is example command:
echo "Verifying arguments for run.neighborhoods.py"
echo "——————————————————————"
echo "${ABCREPOSITORYSRCDIRECTORY}/run.neighborhoods.py"
echo "src/run.neighborhoods.py"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.candidateRegions.bed"
echo "example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted.candidateRegions.bed"
echo "——————————————————————"
echo "${REFERENCECHROMOSOMEDIRECTORY}/${REFERENCESEQUENCEBED}.chr22.bed"
echo "example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.chr22.bed"
echo "——————————————————————"
echo "${INPUTDIRECTORY}/${INPUTBAMFORNEIGHBORHOODS}"
echo "example_chr22/input_data/Chromatin/ENCFF384ZZM.chr22.bam"
echo "——————————————————————"
echo "${INPUTBAM},${INPUTDIRECTORY}/${INPUTFILENAME%Rep1}Rep2.chr22.bam"
echo "example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam,example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep2.chr22.bam"
echo "——————————————————————"
echo "${INPUTDIRECTORY}/Expression/${EXPRESSIONTABLETXT}"
echo "example_chr22/input_data/Expression/K562.ENCFF934YBO.TPM.txt"
echo "——————————————————————"
echo "${REFERENCECHROMOSOMEDIRECTORY}/chr22"
echo "example_chr22/reference/chr22"
echo "——————————————————————"
echo "./reference/${UBIQUITOUSLYEXPRESSEDGENESTXT}"
echo "reference/UbiquitouslyExpressedGenesHG19.txt"
echo "——————————————————————"
echo "${CELLTYPEIDENTIFIER}"
echo "K562"
echo "——————————————————————"
echo "${OUTPUTDIRECTORY}/Neighborhoods/"
echo "example_chr22/ABC_output/Neighborhoods/"
echo "——————————————————————"
python3 "${ABCREPOSITORYSRCDIRECTORY}/run.neighborhoods.py" \
        --candidate_enhancer_regions "${OUTPUTDIRECTORY}/Peaks/${INPUTFILENAME}.macs2_peaks.narrowPeak.sorted.candidateRegions.bed" \
        --genes "${REFERENCECHROMOSOMEDIRECTORY}/${REFERENCESEQUENCEBED}.chr22.bed" \
        --H3K27ac "${INPUTDIRECTORY}/${INPUTBAMFORNEIGHBORHOODS}" \
        --DHS "${INPUTDIRECTORY}/${INPUTFILENAME}.chr22.bam,${INPUTDIRECTORY}/${INPUTFILENAME%?}2.chr22.bam" \
        --expression_table "${INPUTDIRECTORY}/../Expression/${EXPRESSIONTABLETXT}" \
        --chrom_sizes "${REFERENCECHROMOSOMEDIRECTORY}/chr22" \
        --ubiquitously_expressed_genes "./reference/${UBIQUITOUSLYEXPRESSEDGENESTXT}" \
        --cellType "${CELLTYPEIDENTIFIER}" \
        --outdir "${OUTPUTDIRECTORY}/Neighborhoods/"