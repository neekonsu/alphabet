#!/bin/sh

git add . && \
git commit -m "$1" && \
git push origin master && \
docker build . -t neekonsu/abc_pipeline:latest && \
docker container run -it --gpus all --name main neekonsu/abc_pipeline:latest