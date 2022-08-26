package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	"path/filepath"

	"github.com/hadenlabs/terraform-aws-ec2-instance/config"
	"github.com/hadenlabs/terraform-aws-ec2-instance/internal/app/external/faker"
	"github.com/hadenlabs/terraform-aws-ec2-instance/internal/testutil"
)

func TestWithAwsKeysSuccess(t *testing.T) {
	t.Parallel()
	conf := config.Initialize()
	tags := map[string]interface{}{
		"tag1": "tags1",
	}
	namespace := testutil.Company
	stage := testutil.Stage
	name := faker.Server().Name()
	enableDocker := true
	publicKey := filepath.Join(conf.App.RootPath, string(testutil.PublicKey))
	privateKey := filepath.Join(conf.App.RootPath, string(testutil.PrivateKey))

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "instance-with-aws-keys",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"namespace":      namespace,
			"stage":          stage,
			"name":           name,
			"enabled_docker": enableDocker,
			"tags":           tags,
			"public_key":     publicKey,
			"private_key":    privateKey,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
	outputInstance := terraform.Output(t, terraformOptions, "instance")
	assert.NotEmpty(t, outputInstance, outputInstance)
}
