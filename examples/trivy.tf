/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */

module "trivy-operator" {
  source = "github.com/ministryofjustice/cloud-platfrom-terraform-trivy-operator?ref=0.2.5"

  dockerhub_username      = var.dockerhub_username
  dockerhub_password      = var.dockerhub_password
  job_concurrency_limit   = 5
  scan_job_timeout        = "10m"
  trivy_timeout           = "10m0s"
  severity_list           = "HIGH,CRITICAL"
  service_monitor_enabled = true
}
