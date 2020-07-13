#!/bin/sh

INPUTBAM=$1
OUTPUTMACS2=$2
OUTPUTDIRECTORY=$3

macs2 callpeak \
            -t $INPUTBAM \
            -n $OUTPUTMACS2 \
            -f BAM \
            -g hs \
            -p .1 \
            --call-summits \
            --outdir $OUTPUTDIRECTORY