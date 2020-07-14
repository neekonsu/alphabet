package abcscripts

import (
	"fmt"
	"os"
	"os/exec"
)

// StageOne function runs stage1 of procedure described in README.md
func StageOne(INPUTBAM string,
	OUTPUTMACS2 string,
	OUTPUTDIRECTORY string,
	REFERENCECHROMOSOMEDIRECTORY string,
	ABCREPOSITORYPYTHONDIRECTORY string) {
	// Spawn shell command for `stage1.sh` script
	stage1 := &exec.Cmd{
		Path:   "./stage1.sh",
		Args:   []string{INPUTBAM, OUTPUTMACS2, OUTPUTDIRECTORY, REFERENCECHROMOSOMEDIRECTORY},
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
