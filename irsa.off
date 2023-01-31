data "aws_iam_policy_document" "trivy_policy_document" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
    resources = [
      "arn:aws:ecr:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "trivy_policy" {
  name        = "trivy-ecr-readonly-policy"
  path        = "/cloud-platform/"
  policy      = data.aws_iam_policy_document.trivy_policy_document.json
  description = "Policy for trivy readonly access to ECR for image pulls"
}

module "irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=1.0.6"

  eks_cluster_name = var.eks_cluster_name
  namespace        = "trivy-system"
  role_policy_arns = [aws_iam_policy.trivy_policy.arn]
}

resource "kubernetes_secret" "irsa" {
  metadata {
    name      = "trivy-irsa"
    namespace = "trivy-system"
  }
  data = {
    role           = module.irsa.aws_iam_role_name
    serviceaccount = module.irsa.service_account_name.name
  }
}
