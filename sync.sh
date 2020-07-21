#!/bin/sh
git add . && \
git commit -m "$1" && \
git push origin master && \
docker container start -ai main