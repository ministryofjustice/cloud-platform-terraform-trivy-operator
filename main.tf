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

resource "helm_release" "trivy-system" {
  name       = "trivy-system"
  namespace  = kubernetes_namespace.trivy-system.id
  repository = "https://aquasecurity.github.io/helm-charts/"
  chart      = "trivy-operator"
  version    = "0.10.2"

  values = [
    templatefile("${path.module}/templates/values.yaml.tpl",
      { severity-level      = var.severity_list,
        github-access-token = var.github_token
    })
  ]

  set {
    name  = "serviceMonitor.enabled"
    value = var.service_monitor
  }

  depends_on = [kubernetes_namespace.trivy-system]

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "kubernetes_secret" "dockerhub_credentials" {
  metadata {
    name      = "dockerhub-credentials"
    namespace = kubernetes_namespace.trivy-system.id
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


module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.13.0"
  create_role                   = true
  role_name                     = "trivy.${var.cluster_domain_name}"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:trivy-system:trivy-system-trivy-operator"]
}
