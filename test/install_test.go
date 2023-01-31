package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

var (
	namespaceName = "trivy-system"
	options       = k8s.NewKubectlOptions("", "", namespaceName)
)

func TestMain(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func TestServiceCreation(t *testing.T) {
	t.Parallel()

	svc, err := k8s.RunKubectlAndGetOutputE(t, options, "get", "svc")
	if err != nil {
		t.Fatal(err)
	}

	if svc == "" {
		t.Fatal("Service is not created")
	}
}

func TestDeploymentCreation(t *testing.T) {
	t.Parallel()

	deploy, err := k8s.RunKubectlAndGetOutputE(t, options, "get", "deploy")
	if err != nil {
		t.Fatal(err)
	}

	if deploy == "" {
		t.Fatal("Deployment is not created")
	}
}

func TestNamespaceCreation(t *testing.T) {
	t.Parallel()

	ns, err := k8s.GetNamespaceE(t, options, namespaceName)
	if err != nil {
		t.Fatal(err)
	}

	if ns.Name != namespaceName {
		t.Fatalf("Namespace name is not %s", namespaceName)
	}

}
