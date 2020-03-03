package testing

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"

	cwe "github.com/GSA/grace-tftest/aws/cloudwatchevents"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestOne(t *testing.T) {
	err := os.Setenv("TF_LOG", "TRACE")
	if err != nil {
		t.Fatalf("failed to set TF_LOG: %v", err)
	}

	opts := &terraform.Options{
		NoColor: true,
	}
	t.Logf("output: %s\n", terraform.InitAndApply(t, opts))

	url := "http://localhost:5000"
	sess, err := session.NewSession(&aws.Config{
		Endpoint:   aws.String(url),
		DisableSSL: aws.Bool(true),
	})
	if err != nil {
		t.Fatalf("failed to connect to moto: %s -> %v", url, err)
	}

	svc := cwe.New(sess)
	target := svc.Rule.Name("scp_changes").Assert(t, nil).Target()
	assert.Nil(t, target)
}
