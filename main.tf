data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "kubernetes_namespace" "trivy-system" {
  metadata {
    name = "trivy-system"

    labels = {
      "name"                                           = "trivy-system"
      "component"                                      = "trivy-system"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "trivy-system"
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/slack-channel" = "cloud-platform"
      "cloud-platform-out-of-hours-alert"           = "true"
    }
  }
}

resource "kubernetes_secret" "dockerhub_credentials" {

  metadata {
    name      = "dockerhub-credentials"
    namespace = kubernetes_namespace.monitoring.id
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://index.docker.io/v1": {
      "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}")}"
    }
  }
}
DOCKER
  }
}

resource "helm_release" "trivy-system" {
  name       = "trivy-system"
  namespace  = kubernetes_namespace.trivy-system.id
  repository = "https://aquasecurity.github.io/helm-charts/"
  chart      = "trivy-operator"
  version    = "0.10.1"

  values = [
    templatefile("${path.module}/templates/values.yaml.tpl",
      { severity-level = var.severity_list },
    { github-access-token = var.github_token })
  ]

  lifecycle {
    ignore_changes = [keyring]
  }

}
