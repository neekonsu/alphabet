#!/bin/sh

docker container rm -f $(docker ps -aq)
go build -o main/alphabet -i main/main.go
docker build . -t neekonsu/alphabet:latest
docker container run -it --gpus all neekonsu/alphabet:latest