package alphabet

import (
	"fmt"
	"os"
	"os/exec"
)

// StageThree function runs stage3 of procedure described in README.md
func StageThree(args *[]string) {
	// Spawn shell command for `stage1.sh` script
	stage1 := &exec.Cmd{
		Path:   "sh /alphabet/stage3.sh",
		Args:   (*args),
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
