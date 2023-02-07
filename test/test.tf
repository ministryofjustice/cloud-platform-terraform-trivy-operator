module "test_module" {
  source = "../"

  service_monitor_enabled = false

  cluster_domain_name = "cluster.local"
  role_key_annotation = ""
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
