package alphabet

import (
	"fmt"
	"os"
	"os/exec"
)

// StageTwo function runs stage2 of procedure described in README.md
func StageTwo(args *[]string) {
	// Spawn shell command for `stage2.sh` script
	stage2 := &exec.Cmd{
		Path:   ".stage2.sh",
		Args:   (*args),
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage2.Run(); err != nil {
		fmt.Println(err)
	}
}
