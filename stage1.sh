#!/bin/sh

INPUTBAM=$0
OUTPUTMACS2=$1
OUTPUTDIRECTORY=$2

echo "0: $0, 1: $1, 2: $2" >&2

macs2 callpeak \
            -t $INPUTBAM \
            -n $OUTPUTMACS2 \
            -f BAM \
            -g hs \
            -p .1 \
            --call-summits \
            --outdir $OUTPUTDIRECTORY