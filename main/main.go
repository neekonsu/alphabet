package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	fmt.Println("##### Simple Shell #####")
	fmt.Println("————————————————————————")
	i := 4
	var stage1Args []string
	var defaults []string = [
		"Path to input DNase-Seq or ATAC-Seq Bam file,\n
		ex: ./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam",
		"Path to MACS2 output file,\n
		ex: ./wgEncodeUwDnaseK562AlnRep1.chr22.macs2",
		"Path to general MACS2 output directory,\n
		ex: ./example_chr22/ABC_output/Peaks/",
		"Path to ABC python src directory,\n
		ex: ./src",
	]
	for {
		fmt.Print("-> ")
		text, _ := reader.ReadString('\n')
		// convert CRLF to LF
		text = strings.Replace(text, "\n", "", -1)
		stage1Args = append(stage1Args, text)
		if i--; i == 0 {
			break
		}
	}
	// INPUTBAM := flag.String("INPUTBAM",
	// 	"./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam",
	// 	"Path to input DNase-Seq or ATAC-Seq Bam file")
	// OUTPUTMACS2 := flag.String("OUTPUTMACS2",
	// 	"./wgEncodeUwDnaseK562AlnRep1.chr22.macs2",
	// 	"Path to MACS2 output file")
	// OUTPUTDIRECTORY := flag.String("OUTPUTDIRECTORY",
	// 	"./example_chr22/ABC_output/Peaks/",
	// 	"Path to general MACS2 output directory")
	// abcscripts.StageOne(*INPUTBAM, *OUTPUTMACS2, *OUTPUTDIRECTORY)
	// abcscripts.StageTwo()
	// abcscripts.StageThree()
}
