#!/bin/sh
go build -o main/alphabet -i main/main.go
chmod +x main/alphabet
git add . && \
git commit -m "$1" && \
git push origin master