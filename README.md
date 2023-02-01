# Cloud Platform Trivy Operator Module

<!-- Change the URL in the release badge to point towards your new repository -->
[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-trivy-operator/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-trivy-operator/releases)

<!-- Add a short description of the module -->
This Terraform module will install a Kubernetes namespace and [Trivy operator](https://aquasecurity.github.io/trivy-operator/v0.1.5/operator/installation/helm/) in your cluster.

## How to test

There are tests in this module that assert the output of a module install. This is useful for checking changes won't break the expected. You can run these tests continuously using the following methods:

#### Pre-build cluster

If you're using a pre-built cluster and are ready to install, you can simply run:

```bash
make test
```

This should apply the Trivy module using test parameters, assert its output and destroy it.

#### Kind cluster

Kind clusters are created locally and give you fast feedback on changes.

To create a kind cluster you must have the [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) binary installed, then run this command:

```bash
make cluster-up
```

Make your changes and test with:

```bash
make test
```

Once you're finished simply delete the cluster with:

```bash
make cluster-down
```

#### Act

Sometimes you want to run exactly what's being executed in the GitHub Action CI. To do this, install [act](https://github.com/nektos/act/blob/master/README.md#installation) and run the following command:

```bash
act --container-architecture linux/amd64 -W ./.github/workflows/unit.yml
```

#### Terraform/manually

To test manually, go into the `test` directory and run:

```bash
terraform init
terraform apply
```

When you're finished, run:

```bash
terraform destroy
```

## Usage

```hcl
module "template" {
  source = "github.com/ministryofjustice/cloud-platfrom-terraform-trivy-operator?ref=version"
}
```

See the [examples/](examples/) folder for more information.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.trivy-system](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.trivy-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.dockerhub_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dockerhub_password"></a> [dockerhub\_password](#input\_dockerhub\_password) | DockerHub password - required to avoid hitting Dockerhub API limits in EKS clusters | `string` | `""` | no |
| <a name="input_dockerhub_username"></a> [dockerhub\_username](#input\_dockerhub\_username) | DockerHub username - required to avoid hitting Dockerhub API limits in EKS clusters | `string` | `""` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub Personal Access Token | `string` | `""` | no |
| <a name="input_service_monitor"></a> [service\_monitor](#input\_service\_monitor) | Enable ServiceMonitor for Prometheus Operator | `bool` | `true` | no |
| <a name="input_severity_list"></a> [severity\_list](#input\_severity\_list) | A single string providing comma separated list of CVE Severity levels to be monitored. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL | `string` | `"UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

<!-- Uncomment the below if this module uses tags -->

<!--
## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |
| namespace |  | string | - | yes |
-->

## Reading Material

<!-- Add links to external sources, e.g. Kubernetes or AWS documentation -->

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
