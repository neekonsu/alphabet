package ABC_scripts

import (
	"flag"
	"fmt"
	"os/exec"
)

func main() {
	INPUTBAM := flag.String("jsonPath", "./res", "Path to directory storing JSON metadata files")
	OUTPUTMACS2 := flag.String("agreementPath", "./agreementAccessions.csv", "Path to agreement accessions csv")
	OUTPUTDIRECTORY := flag.String("outputAccessionsPath", "./accessions.csv", "Path to output accessions csv file")
	stage1 = exec.Command("./stage1.sh", INPUTBAM, OUTPUTMACS2, OUTPUTDIRECTORY)
	_, err = stage1.Output()
	if err != nil {
		fmt.Println(err)
	}
}
