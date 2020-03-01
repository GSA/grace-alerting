package testing

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"testing"

	"net/http"
)

func TestNow(t *testing.T) {

	err := os.Setenv("AWS_ACCESS_KEY_ID", "foobar")
	if err != nil {
		t.Fatalf("failed to set AWS_ACCESS_KEY_ID: %v", err)
	}

	err = os.Setenv("AWS_SECRET_ACCESS_KEY", "foobar")
	if err != nil {
		t.Fatalf("failed to set AWS_SECRET_ACCESS_KEY: %v", err)
	}

	cwd, err := os.Getwd()
	if err != nil {
		t.Fatalf("failed to get current working directory: %v", cwd)
	}

	cases := map[string]Case{
		"one": {
			path: "cases/one/integration_test.go",
			port: 5000,
		},
	}
	for _, c := range cases {
		err = c.Run()
		if err != nil {
			fmt.Printf("failed to execute case: %s -> %v", c.path, err)
		}
	}
}

type Case struct {
	path string
	port int
}

func (c *Case) Run() error {
	cmd := exec.Command("moto_server", "-p", strconv.Itoa(c.port))
	go func() {
		err := cmd.Run()
		if err != nil {
			fmt.Printf("failed to execute moto_server: %v", err)
		}
	}()

	url := fmt.Sprintf("http://localhost:%d", c.port)
	// wait for a response from moto_server
	_, err := http.Get(url)
	if err != nil {
		return fmt.Errorf("failed to connect to %s -> %v", url, err)
	}

	cmd = exec.Command("/usr/local/go/bin/go", "test", c.path)

	err = cmd.Run()
	if err != nil {
		return fmt.Errorf("failed to execute case: %s -> %v", c.path, err)
	}
}
