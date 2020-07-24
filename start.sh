#!/bin/sh

cd alphabet && \
git pull origin master && \
# gunzip ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Predictions/EnhancerPredictionsAllPutative.txt.gz && \
# gunzip -S ".bam" ABC-Enhancer-Gene-Prediction/example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Predictions/EnhancerPredictionsAllPutativeNonExpressedGenes.txt.gz ABC-Enhancer-Gene-Prediction/example_chr22/input_data/Chromatin/ENCFF384ZZM.chr22.bam ABC-Enhancer-Gene-Prediction/example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam ABC-Enhancer-Gene-Prediction/example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep2.chr22.bam && \
go run "main/main.go"