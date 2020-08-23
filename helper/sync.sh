#!/bin/sh
go build -o main/alphabet -i main/main.go
chmod +x main/alphabet
git submodule foreach git add -A
git submodule foreach git commit -m "$1"
git submodule foreach git push origin master
git add .
git commit -m "$1"
git push --recurse-submodules=on-demand origin master