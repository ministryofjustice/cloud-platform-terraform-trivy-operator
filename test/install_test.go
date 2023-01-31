package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTrivyModuleInstall(t *testing.T) {
	var (
		namespaceName = "trivy-system"
		options       = k8s.NewKubectlOptions("", "", namespaceName)
	)
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./",
	})

	t.Cleanup(func() {
		terraform.Destroy(t, terraformOptions)
	})

	terraform.InitAndApply(t, terraformOptions)

	svc, err := k8s.RunKubectlAndGetOutputE(t, options, "get", "svc")
	if err != nil {
		t.Fatal(err)
	}

	if svc == "" {
		t.Fatal("Service is not created")
	}

	deploy, err := k8s.RunKubectlAndGetOutputE(t, options, "get", "deploy")
	if err != nil {
		t.Fatal(err)
	}

	if deploy == "" {
		t.Fatal("Deployment is not created")
	}

	ns, err := k8s.GetNamespaceE(t, options, namespaceName)
	if err != nil {
		t.Fatal(err)
	}

	if ns.Name != namespaceName {
		t.Fatalf("Namespace name is not %s", namespaceName)
	}

}
