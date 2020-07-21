#!/bin/sh

conda init bash && \
. "/root/.bashrc" && \
conda env create -f "./alphabet/conda.yml" && \
conda activate environment && \
cd alphabet && \
git pull origin master && \
go run "main/main.go"