package testing

import (
	"fmt"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"

	cwe "github.com/GSA/grace-tftest/aws/cloudwatchevents"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
)

func TestIntegration(t *testing.T) {
	port := os.Getenv("MOTO_PORT")
	if len(port) == 0 {
		t.Skipf("skipping testing, MOTO_PORT not set in environment variables")
	}

	url := "http://localhost:" + port
	fmt.Printf("connecting to: %s\n", url)
	sess, err := session.NewSession(&aws.Config{
		Endpoint:   aws.String(url),
		DisableSSL: aws.Bool(true),
	})
	if err != nil {
		t.Fatalf("failed to connect to moto: %s -> %v", url, err)
	}

	svc := cwe.New(sess)
	target := svc.
		Rule.
		Name("scp_changes").
		Assert(t, nil).
		Target()
	assert.Nil(t, target)
}
