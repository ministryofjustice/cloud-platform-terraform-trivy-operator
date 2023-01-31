provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "trivy-operator" {
  source = "../"

  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub.password

  severity_list = "HIGH,CRITICAL"
}
