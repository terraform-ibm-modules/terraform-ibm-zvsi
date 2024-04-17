package test

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"testing"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const completeExampleDir = "examples/complete"
const quickStartPatternTerraformDir = "solutions/quickstart"
const standardPatternTerraformDir = "solutions/standard"

//var permanentResources map[string]interface{}

//var sharedInfoSvc *cloudinfo.CloudInfoService

// TestMain will be run before any parallel tests, used to set up a shared InfoService object to track region usage
// for multiple tests
//func TestMain(m *testing.M) {
//	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

//	var err error
//	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
//	if err != nil {
//		log.Fatal(err)
//	}

//	os.Exit(m.Run())
//}

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
		//	Prefix:       prefix_var,
		//	Region:       region_var,
		TerraformVars: map[string]interface{}{
			"ssh_key": sshPublicKey,
			"prefix":  prefix_var,
			"region":  region_var,
		},
	})
	return options
}

func setupOptionsStandardPattern(t *testing.T, prefix_var string, region_var string, dir string) *testhelper.TestOptions {

	sshPublicKey := sshPublicKeyStandard(t)

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		TerraformVars: map[string]interface{}{
			"ssh_key":          sshPublicKey,
			"prefix":           prefix_var,
			"region":           region_var,
			"cert_common_name": "standardtestcert",
		},
	})
	return options
}

func TestRunCompleteExampleQuickstart(t *testing.T) {
	t.Parallel()

	options := setupOptionsQuickStartPattern(t, "quickstarttest", "br-sao", quickStartPatternTerraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunCompleteExampleStandard(t *testing.T) {
	t.Parallel()

	options := setupOptionsQuickStartPattern(t, "standardtest", "br-sao", standardPatternTerraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
