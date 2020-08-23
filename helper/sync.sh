#!/bin/sh
go build -o main/alphabet -i main/main.go
chmod +x main/alphabet
git submodule update --init
git commit -am "$1"
git push --recurse-submodules=on-demand origin master