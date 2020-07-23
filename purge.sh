#!/bin/sh

docker container rm -f $(docker ps -aq)