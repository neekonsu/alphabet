#!/bin/bash

cd alphabet
git pull --recurse-submodules=on-demand origin master
git submodule update --init
./main/alphabet