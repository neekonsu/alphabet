#!/bin/sh

docker build . -t neekonsu/abc_pipeline:latest && \
docker container run -it --gpus all --name main neekonsu/abc_pipeline:latest