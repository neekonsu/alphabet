#!/bin/sh

conda init bash && \
. "/root/.bashrc" && \
# conda env create -f "./alphabet/conda.yml" && \
# conda env activate zerpzorp && \
cd alphabet && \
git pull origin master && \
go run "main/main.go"