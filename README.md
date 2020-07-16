# Alphabet ![Alphabet logo](Drawing.png)
###     The Activity By Contact pipeline wrapper
## In order for the pipeline to function properly, please adhere to the filestructure defined in https://github.com/neekonsu/ABC-Enhancer-Gene-Prediction
## Check https://hub.docker.com/repository/docker/neekonsu/abc_pipeline/general for docker container preloaded with pipeline and template filestructure as well as example data
# How to run:
## With git repository:
### Direct execution:
        |$⟩ mkdir -p ./go/src/github.com/neekonsu
        |$⟩ cd ./go/src/github.com/neekonsu
        |$⟩ git clone https://github.com/neekonsu/Alphabet.git
        |$⟩ cd Alphabet
        |$⟩ chmod +x stage1.sh stage2.sh stage3.sh
        |$⟩ go run main/main.go
### Containerized execution:
        |$⟩ mkdir -p ./go/src/github.com/neekonsu
        |$⟩ cd ./go/src/github.com/neekonsu
        |$⟩ git clone https://github.com/neekonsu/Alphabet.git
        |$⟩ cd Alphabet
        |$⟩ docker build . -t alphabet:latest
        |$⟩ docker container run -it --rm --gpus all --name Nickname alphabet:latest
## With Docker Container:
        |$⟩ docker pull neekonsu/abc_pipeline:latest
        |$⟩ docker container run -it --rm --gpus all --name Nickname neekonsu/abc_pipeline:latest
## Pipeline Procedure and Notes:
### 1. Define candidate enhancer regions
    a. Call peaks on a DNase-seq or ATAC-seq bam file using MACS2
    b. Process ^peaks^ using 'makeCandidateRegions.py'
        1. Input 'narrowPeak' file output by ^MACS2^ to 'makeCandidateRegions.py'; this will execute the following:
            1. Count DNase-seq reads in each peak and retain the top N peaks with the most read counts
            2. Resize each of these N peaks to be a fixed number of base pairs centered on the peak summit
            3. Remove any blacklisted regions and include any whitelisted regions
            4. Merge any overlapping regions
        2. Example command for ^step 1^:
            `macs2 callpeak \
            -t example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
            -n wgEncodeUwDnaseK562AlnRep1.chr22.macs2 \
            -f BAM \
            -g hs \
            -p .1 \
            --call-summits \
            --outdir example_chr22/ABC_output/Peaks/`

            #Sort narrowPeak file
            `bedtools sort -faidx example_chr22/reference/chr22 \
            -i example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak > example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted`

            #May need to change virtual environments here
            `python src/makeCandidateRegions.py \
            --narrowPeak example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted \
            --bam example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
            --outDir example_chr22/ABC_output/Peaks/ \
            --chrom_sizes example_chr22/reference/chr22 \
            --regions_blacklist reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed \
            --regions_whitelist example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed \
            --peakExtendFromSummit 250 \
            --nStrongestPeaks 3000`
        3. Check "### Step 1. Define candidate elements" in README.md of 'ABC-Enhancer-Gene-Prediction' for commentary on methods
### 2. Quantify enhancer activity
    a. Input DNase-Seq/ATAC-Seq & H3K27ac ChIP-Seq reads to 'run.neighborhoods.py'; following is example command:
        `
        python src/run.neighborhoods.py \
        --candidate_enhancer_regions example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted.candidateRegions.bed \
        --genes example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.chr22.bed \
        --H3K27ac example_chr22/input_data/Chromatin/ENCFF384ZZM.chr22.bam \
        --DHS example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam,example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep2.chr22.bam \
        --expression_table example_chr22/input_data/Expression/K562.ENCFF934YBO.TPM.txt \
        --chrom_sizes example_chr22/reference/chr22 \
        --ubiquitously_expressed_genes reference/UbiquitouslyExpressedGenesHG19.txt \
        --cellType K562 \
        --outdir example_chr22/ABC_output/Neighborhoods/ 
        `
    b. ^'run.neighborhoods.py'^ returns 2 files:
        1. **EnhancerList.txt**: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
        2. **GeneList.txt**: Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions
### 3. Compute ABC Scores
    a. Input all ouput of ^'run.neighborhoods.py'^ to 'predict.py'; following is example command:
        `
        python src/predict.py \
        --enhancers example_chr22/ABC_output/Neighborhoods/EnhancerList.txt \
        --genes example_chr22/ABC_output/Neighborhoods/GeneList.txt \
        --HiCdir example_chr22/input_data/HiC/raw/ \
        --hic_resolution 5000 \
        --scale_hic_using_powerlaw \
        --threshold .02 \
        --cellType K562 \
        --outdir example_chr22/ABC_output/Predictions/ \
        --make_all_putative
        `
    b. ^'predict.py'^ returns 5 files:
        1. **EnhancerPredictions.txt**: all element-gene pairs with scores above the provided threshold.
           Only includes expressed genes and does not include promoter elements. 
           This file defines the set of 'positive' predictions of the ABC model.
        2. **EnhancerPredictionsFull.txt**: same as above but includes more columns. 
           See <https://docs.google.com/spreadsheets/d/1UfoVXoCxUpMNPfGypvIum1-RvS07928grsieiaPX67I/edit?usp=sharing> for column definitions
        3. **EnhancerPredictions.bedpe**: Same as above in .bedpe format. Can be loaded into IGV.
        4. **EnhancerPredictionsAllPutative.txt.gz**: ABC scores for all element-gene pairs. 
           Includes promoter elements and pairs with scores below the threshold. 
           Only includes expressed genes. This file includes both the 'positive' and 'negative' predictions of the model. 
           (use ```--make_all_putative``` to generate this file).
        5. **EnhancerPredictionsAllPutativeNonExpressedGenes.txt.gz**: Same as above for non-expressed genes. 
           This file is provided for completeness but we generally do not recommend using these predictions.