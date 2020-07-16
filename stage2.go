package alphabet

import (
	"fmt"
	"os"
	"os/exec"
)

// StageTwo function runs stage2 of procedure described in README.md
func StageTwo(args *[]string) {
	// Spawn shell command for `stage1.sh` script
	stage1 := &exec.Cmd{
		Path:   "./stage2.sh",
		Args:   (*args),
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
