#!/bin/sh

docker container rm -f $(docker ps -aq)
docker build . -t neekonsu/alphabet:latest
docker container run -it --gpus all neekonsu/alphabet:latest