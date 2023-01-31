provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */

module "trivy-operator" {
  source = "github.com/ministryofjustice/cloud-platfrom-terraform-trivy-operator?ref=version"

  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub.password

  severity_list = "HIGH,CRITICAL"
}
