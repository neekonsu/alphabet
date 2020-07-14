package abcscripts

import (
	"fmt"
	"os"
	"os/exec"
)

// StageOne function runs stage1 of procedure described in README.md
func StageOne(INPUTBAM string, OUTPUTMACS2 string, OUTPUTDIRECTORY string) {
	// INPUTBAM := flag.String("INPUTBAM", "./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam", "Path to input DNase-Seq or ATAC-Seq Bam file")
	// OUTPUTMACS2 := flag.String("OUTPUTMACS2", "./wgEncodeUwDnaseK562AlnRep1.chr22.macs2", "Path to MACS2 output file")
	// OUTPUTDIRECTORY := flag.String("OUTPUTDIRECTORY", "./example_chr22/ABC_output/Peaks/", "Path to general MACS2 output directory")
	stage1 := &exec.Cmd{
		Path:   "./stage1.sh",
		Args:   []string{INPUTBAM, OUTPUTMACS2, OUTPUTDIRECTORY},
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
