package test

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"testing"
)

// Use existing resource group
// const resourceGroup = "geretain-test-resources"
// const completeExampleDir = "examples/complete"
const quickStartPatternTerraformDir = "solutions/quickstart"
const standardPatternTerraformDir = "solutions/standard"

func sshPublicKeyQuickstart(t *testing.T) string {
	pubKey, keyErr := common.GenerateSshRsaPublicKey()

	// if error producing key (very unexpected) fail test immediately
	require.NoError(t, keyErr, "SSH Keygen failed, without public ssh key test cannot continue")

	return pubKey
}

func sshPublicKeyStandard(t *testing.T) string {
	pubKey, keyErr := common.GenerateSshRsaPublicKey()

	// if error producing key (very unexpected) fail test immediately
	require.NoError(t, keyErr, "SSH Keygen failed, without public ssh key test cannot continue")

	return pubKey
}

func setupOptionsQuickStartPattern(t *testing.T, prefix_var string, region_var string, dir string) *testhelper.TestOptions {

	sshPublicKey := sshPublicKeyQuickstart(t)

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix_var,
	})

	options.TerraformVars = map[string]interface{}{
		"ssh_key": sshPublicKey,
		"prefix":  options.Prefix,
		"region":  region_var,
	}

	return options
}

func setupOptionsStandardPattern(t *testing.T, prefix_var string, region_var string, dir string) *testhelper.TestOptions {

	sshPublicKey := sshPublicKeyStandard(t)

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix_var,
	})

	options.TerraformVars = map[string]interface{}{
		"ssh_public_key":   sshPublicKey,
		"prefix":           options.Prefix,
		"region":           region_var,
		"cert_common_name": "standardtestcert",
	}

	return options
}

func TestRunQuickstart(t *testing.T) {
	t.Parallel()

	options := setupOptionsQuickStartPattern(t, "qs", "br-sao", quickStartPatternTerraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunStandard(t *testing.T) {
	t.Parallel()

	options := setupOptionsStandardPattern(t, "std", "br-sao", standardPatternTerraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeQuickstart(t *testing.T) {
	t.Parallel()

	options := setupOptionsQuickStartPattern(t, "qsupg", "br-sao", quickStartPatternTerraformDir)
	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestRunUpgradeStandard(t *testing.T) {
	t.Parallel()

	options := setupOptionsStandardPattern(t, "stdupg", "br-sao", standardPatternTerraformDir)
	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
