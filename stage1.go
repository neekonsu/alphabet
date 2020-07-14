package abcscripts

import (
	"fmt"
	"os"
	"os/exec"
)

// StageOne function runs stage1 of procedure described in README.md
func StageOne(INPUTBAM string, OUTPUTMACS2 string, OUTPUTDIRECTORY string) {
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
