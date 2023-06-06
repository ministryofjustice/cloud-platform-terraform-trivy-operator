# Cloud Platform Trivy Operator Module

<!-- Change the URL in the release badge to point towards your new repository -->
[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-trivy-operator/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-trivy-operator/releases)

<!-- Add a short description of the module -->
This Terraform module will install a Kubernetes namespace and [Trivy operator](https://aquasecurity.github.io/trivy-operator/v0.1.5/operator/installation/helm/) in your cluster.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 3.13.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.trivy-system](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.trivy-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_domain_name"></a> [cluster\_domain\_name](#input\_cluster\_domain\_name) | The cluster domain used for iam\_assumable\_role\_admin role name | `any` | n/a | yes |
| <a name="input_cpu_limit"></a> [cpu\_limit](#input\_cpu\_limit) | resources:limits CPU value | `string` | `"500m"` | no |
| <a name="input_cpu_limit_non_live"></a> [cpu\_limit\_non\_live](#input\_cpu\_limit\_non\_live) | Non-live cluster value for resources:limits CPU value | `string` | `"500m"` | no |
| <a name="input_cpu_requests"></a> [cpu\_requests](#input\_cpu\_requests) | resources:requests CPU value | `string` | `"100m"` | no |
| <a name="input_cpu_requests_non_live"></a> [cpu\_requests\_non\_live](#input\_cpu\_requests\_non\_live) | Non-live cluster value for resources:requests CPU value | `string` | `"100m"` | no |
| <a name="input_dockerhub_password"></a> [dockerhub\_password](#input\_dockerhub\_password) | DockerHub password - required to avoid hitting Dockerhub API limits in EKS clusters | `string` | `""` | no |
| <a name="input_dockerhub_username"></a> [dockerhub\_username](#input\_dockerhub\_username) | DockerHub username - required to avoid hitting Dockerhub API limits in EKS clusters | `string` | `""` | no |
| <a name="input_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#input\_eks\_cluster\_oidc\_issuer\_url) | This is going to be used when we create the IAM OIDC role | `string` | `""` | no |
| <a name="input_enable_config_audit"></a> [enable\_config\_audit](#input\_enable\_config\_audit) | flag to enable configuration audit scanner | `string` | `"false"` | no |
| <a name="input_enable_infra_assess"></a> [enable\_infra\_assess](#input\_enable\_infra\_assess) | flag to enable infra assessment scanner | `string` | `"false"` | no |
| <a name="input_enable_rbac_assess"></a> [enable\_rbac\_assess](#input\_enable\_rbac\_assess) | flag to enable rbac assessment scanner | `string` | `"false"` | no |
| <a name="input_enable_secret_scan"></a> [enable\_secret\_scan](#input\_enable\_secret\_scan) | flag to enable exposed secret scanner | `string` | `"false"` | no |
| <a name="input_enable_trivy_server"></a> [enable\_trivy\_server](#input\_enable\_trivy\_server) | Enable built-in trivy server (clientServer mode). If true, do not set githubToken value | `string` | `"false"` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub Personal Access Token | `string` | `""` | no |
| <a name="input_job_concurrency_limit"></a> [job\_concurrency\_limit](#input\_job\_concurrency\_limit) | Sets the maximum value for concurrent report jobs | `number` | `10` | no |
| <a name="input_memory_limit"></a> [memory\_limit](#input\_memory\_limit) | resources:limit memory value | `string` | `"1000M"` | no |
| <a name="input_memory_limit_non_live"></a> [memory\_limit\_non\_live](#input\_memory\_limit\_non\_live) | Non-live cluster value for resources:limit memory value | `string` | `"500M"` | no |
| <a name="input_memory_requests"></a> [memory\_requests](#input\_memory\_requests) | resources:requests memory value | `string` | `"500M"` | no |
| <a name="input_memory_requests_non_live"></a> [memory\_requests\_non\_live](#input\_memory\_requests\_non\_live) | Non-live clustrer value for resources:requests memory value | `string` | `"100M"` | no |
| <a name="input_role_key_annotation"></a> [role\_key\_annotation](#input\_role\_key\_annotation) | The annotation key to use for the role key | `string` | `"eks.amazonaws.com/role-arn"` | no |
| <a name="input_scan_job_timeout"></a> [scan\_job\_timeout](#input\_scan\_job\_timeout) | The length of time to wait before giving up on a scan job | `string` | `"5m"` | no |
| <a name="input_scanner_report_ttl"></a> [scanner\_report\_ttl](#input\_scanner\_report\_ttl) | flag to set how long a report should exist. When a old report is deleted a new one will be created by the controller. | `string` | `"24h"` | no |
| <a name="input_service_monitor_enabled"></a> [service\_monitor\_enabled](#input\_service\_monitor\_enabled) | Enable ServiceMonitor for Prometheus Operator | `bool` | `true` | no |
| <a name="input_severity_list"></a> [severity\_list](#input\_severity\_list) | A single string providing comma separated list of CVE Severity levels to be monitored. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL | `string` | `"UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL"` | no |
| <a name="input_trivy_service_account"></a> [trivy\_service\_account](#input\_trivy\_service\_account) | Name of the k8s Service Account. If not set, name is generated automatically. | `string` | `""` | no |
| <a name="input_trivy_timeout"></a> [trivy\_timeout](#input\_trivy\_timeout) | Duration to wait for scan completion | `string` | `"5m0s"` | no |

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
