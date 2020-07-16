package alphabet

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// StageTwo function runs stage2 of procedure described in README.md
func StageTwo(INPUTBAM,
	OUTPUTMACS2,
	OUTPUTDIRECTORY,
	REFERENCECHROMOSOMEDIRECTORY,
	ABCREPOSITORYPYTHONDIRECTORY,
	INPUTBAMFORNEIGHBORHOODS string) {
	input := []string{INPUTBAM, OUTPUTMACS2, OUTPUTDIRECTORY, REFERENCECHROMOSOMEDIRECTORY, ABCREPOSITORYPYTHONDIRECTORY}
	for i := range input {
		if strings.HasSuffix(input[i], "/") {
			input[i] = input[i][:len(input)-1]
		}
	}
	// Spawn shell command for `stage1.sh` script
	stage1 := &exec.Cmd{
		Path:   "./stage2.sh",
		Args:   []string{INPUTBAM, OUTPUTMACS2, OUTPUTDIRECTORY, REFERENCECHROMOSOMEDIRECTORY, ABCREPOSITORYPYTHONDIRECTORY},
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
