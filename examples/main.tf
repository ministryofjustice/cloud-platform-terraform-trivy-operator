provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "trivy-operator" {
  source        = "../"
  severity_list = "HIGH,CRITICAL"
}
