package main

import (
	"fmt"
	"log"
	"time"

	abcscripts "github.com/neekonsu/ABC_scripts"
)

// Question represents a single question in user prompt
type Question struct {
	Prompt, Default string
}

func main() {
	// Declare stage1Args to store arguments for stage1.sh
	// Declare and instantiate defaults to store questions for manual input
	var stage1Args [5]string
	defaults := []Question{
		Question{"Path to input DNase-Seq or ATAC-Seq Bam file",
			"./example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam"},
		Question{"Path to MACS2 output file",
			"./wgEncodeUwDnaseK562AlnRep1.chr22.macs2"},
		Question{"Path to general MACS2 output directory",
			"./example_chr22/ABC_output/Peaks"},
		Question{"Path to ABC reference chromosome size directory",
			"example_chr22/reference"},
		Question{"Path to ABC python src directory",
			"./src"},
	}
	// Greet user
	fmt.Println("##### Alphabet, the ABC pipeline wrapper #####")
	fmt.Println("——————————————————————————————————————————————\n")
	for i, question := range defaults {
		fmt.Println(question.Prompt)
		fmt.Println("ex: ", question.Default, " (type default to select example response)")
		fmt.Print("~~> ")
		timeout := time.After(10 * time.Second)
		var input string
		c1 := make(chan string, 1)
		go func() {
			fmt.Scanln(&input)
			c1 <- input
		}()
		select {
		case c1:
			if stage1Args[i] = input; input == "default" {
				stage1Args[i] = question.Default
			} else if input == "" {
				log.Fatalln("No response, please try again")
			}
		case <-timeout:
			log.Fatalln("Input timed out, please try again")
		}
		fmt.Println("——————————————————————————————————————————————")
	}
	if len(stage1Args[4]) == 0 {
		log.Fatalln("One or more fields left empty")
	} else {
		fmt.Println("All arguments set, waiting 3 seconds before starting stage 1 ...")
		time.Sleep(2 * time.Second)
		fmt.Println("Continuing with stage 1.\nStage 1 may take 30s—1min to begin, please be patient.")
		abcscripts.StageOne(stage1Args[0], stage1Args[1], stage1Args[2], stage1Args[3], stage1Args[4])
		abcscripts.StageTwo()
		abcscripts.StageThree()
	}

}
