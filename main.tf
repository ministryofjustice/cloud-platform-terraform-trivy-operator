resource "kubernetes_namespace" "trivy-system" {
  metadata {
    name = "trivy-system"

    labels = {
      "name"                                           = "trivy-system"
      "component"                                      = "trivy-system"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "pod-security.kubernetes.io/enforce"             = "privileged"
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
  version    = "0.25.0"

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    severity_level          = var.severity_list,
    eks_service_account     = aws_iam_role.trivy_operator.arn
    service_monitor_enabled = var.service_monitor_enabled
    role_key_annotation     = var.role_key_annotation
    memory_requests         = can(regex("live", terraform.workspace)) ? var.memory_requests : var.memory_requests_non_live
    cpu_requests            = can(regex("live", terraform.workspace)) ? var.cpu_requests : var.cpu_requests_non_live
    memory_limit            = can(regex("live", terraform.workspace)) ? var.memory_limit : var.memory_limit_non_live
    cpu_limit               = can(regex("live", terraform.workspace)) ? var.cpu_limit : var.cpu_limit_non_live
    job_concurrency_limit   = var.job_concurrency_limit
    scan_job_timeout        = var.scan_job_timeout
    enable_trivy_server     = var.enable_trivy_server
    trivy_service_account   = var.trivy_service_account
    trivy_timeout           = var.trivy_timeout
    scanner_report_ttl      = var.scanner_report_ttl
    enable_config_audit     = var.enable_config_audit
    enable_rbac_assess      = var.enable_rbac_assess
    enable_infra_assess     = var.enable_infra_assess
    enable_secret_scan      = var.enable_secret_scan
    })
  ]

  set_sensitive = [
    {
      name  = "trivy.githubToken"
      value = var.github_token
    }
  ]

  depends_on = [
    kubernetes_namespace.trivy-system
  ]

  lifecycle {
    ignore_changes = [keyring]
  }
}

data "aws_iam_policy_document" "trivy_operator_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.eks_cluster_oidc_issuer_url]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:trivy-system:trivy-system-trivy-operator"]
    }
  }
}

resource "aws_iam_role" "trivy_operator" {
  name               = "trivy.${var.cluster_domain_name}"
  assume_role_policy = data.aws_iam_policy_document.trivy_operator_assume_role.json
}

resource "aws_iam_role_policy_attachment" "trivy_ecr_readonly" {
  role       = aws_iam_role.trivy_operator.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}