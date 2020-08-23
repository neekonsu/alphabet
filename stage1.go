package alphabet

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	pp "github.com/kr/pretty"
)

// StageOne function runs stage1 of procedure described in README.md
func StageOne(args *[]string) {
	for i := range *args {
		if strings.HasSuffix((*args)[i], "/") {
			(*args)[i] = (*args)[i][:len((*args))-1]
		}
	}
	fmt.Println("~~~~~~~~~~~~~~~~~~~~~")
	pp.Println(*args)
	fmt.Println("~~~~~~~~~~~~~~~~~~~~~")
	// Spawn shell command for `stage1.sh` script
	stage1 := &exec.Cmd{
		Path:   "sh /alphabet/stage1.sh",
		Args:   (*args),
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}
	// Generic error handling
	if err := stage1.Run(); err != nil {
		fmt.Println(err)
	}
}
