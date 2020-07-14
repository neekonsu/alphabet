package main

import (
	"flag"

	abcscripts "github.com/neekonsu/ABC_scripts"
)

func main() {
	INPUTBAM := flag.String("INPUTBAM",
		"./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam",
		"Path to input DNase-Seq or ATAC-Seq Bam file")
	OUTPUTMACS2 := flag.String("OUTPUTMACS2",
		"./wgEncodeUwDnaseK562AlnRep1.chr22.macs2",
		"Path to MACS2 output file")
	OUTPUTDIRECTORY := flag.String("OUTPUTDIRECTORY",
		"./example_chr22/ABC_output/Peaks/",
		"Path to general MACS2 output directory")
	abcscripts.StageOne(*INPUTBAM, *OUTPUTMACS2, *OUTPUTDIRECTORY)
	abcscripts.StageTwo()
	abcscripts.StageThree()
}
