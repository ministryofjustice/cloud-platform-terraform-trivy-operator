/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */

module "trivy-operator" {
  source = "../"
  #source = "github.com/ministryofjustice/cloud-platfrom-terraform-trivy-operator?ref=0.1"

  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub_password

  severity_list = "HIGH,CRITICAL"
}
