package main

import (
	"fmt"
	"log"
	"time"

	alphabet "github.com/neekonsu/alphabet"
)

// Question represents a single question in user prompt
type Question struct {
	Prompt, Default string
}

func main() {
	// Declare Args to store arguments for stage1.sh
	// Declare and instantiate defaults to store questions for manual input
	Args := make([]string, 10)
	defaults := []Question{
		Question{"Path to input DNase-Seq or ATAC-Seq Bam file",
			"../ABC-Enhancer-Gene-Prediction/example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam"},
		Question{"Path to general MACS2 output directory",
			"../ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Peaks"},
		Question{"Path to ABC reference chromosome size directory",
			"example_chr22/reference"},
		Question{"Path to ABC python src directory",
			"../ABC-Enhancer-Gene-Prediction/src"},
		Question{"Filename of reference sequence curated (BED)",
			"RefSeqCurated.170308.bed.CollapsedGeneBounds"},
		Question{"Filename Consensus Signal Artifact file",
			"wgEncodeHg19ConsensusSignalArtifactRegions.bed"},
		Question{"Filename input BAM file for run.neighborhoods.py",
			"ENCFF384ZZM.chr22.bam"},
		Question{"Filename of Expression Table txt file",
			"K562.ENCFF934YBO.TPM.txt"},
		Question{"Filename of Ubiquitously Expressed Genes txt file",
			"UbiquitouslyExpressedGenesHG19.txt"},
		Question{"Celltype Identifier string",
			"K562"},
		Question{"HiC resolution for predict.py",
			"5000"},
	}
	// Greet user
	fmt.Println("##### Alphabet, the ABC pipeline wrapper #####")
	fmt.Print("——————————————————————————————————————————————\n\n")
	timeout := time.After(60 * 9 * time.Second)
	for i, question := range defaults {
		fmt.Printf("|%v/%v⟩ %v:\n", (i + 1), len(defaults), question.Prompt)
		fmt.Println("ex: ", question.Default, " (type default to select example response)")
		fmt.Print("~~> ")
		var input string
		c1 := make(chan string, 1)
		go func() {
			fmt.Scanln(&input)
			c1 <- input
		}()
		select {
		case <-c1:
			if Args[i] = input; input == "default" {
				Args[i] = question.Default
			} else if input == "" {
				log.Fatalln("No response, please try again")
			}
		case <-timeout:
			log.Fatalln("Input timed out, please try again")
		}
		fmt.Println("——————————————————————————————————————————————")
	}
	if len(Args[4]) == 0 {
		log.Fatalln("One or more fields left empty")
	} else {
		fmt.Println("All arguments set, waiting 3 seconds before starting stage 1 ...")
		time.Sleep(2 * time.Second)
		fmt.Println("Continuing with stage 1.\nStage 1 may take 30s—1min to begin, please be patient.")
		alphabet.StageOne(&Args)
		fmt.Println(". . . Moving on to next stage, please wait . . . ")
		time.Sleep(2 * time.Second)
		alphabet.StageTwo(&Args)
		fmt.Println(". . . Moving on to next stage, please wait . . . ")
		time.Sleep(2 * time.Second)
		alphabet.StageThree(&Args)
	}
}
