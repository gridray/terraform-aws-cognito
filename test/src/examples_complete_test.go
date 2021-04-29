package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/simple using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	userPoolId := terraform.Output(t, terraformOptions, "id")
	// Verify we're getting back the outputs we expect
	assert.NotEmpty(t, userPoolId)

	// Run `terraform output` to get the value of an output variable
	userPoolArn := terraform.Output(t, terraformOptions, "arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, userPoolArn, "userpool/us-east-2")
}
