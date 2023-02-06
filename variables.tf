variable "severity_list" {
  description = "A single string providing comma separated list of CVE Severity levels to be monitored. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL"
  default     = "UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL"
  type        = string
}

variable "dockerhub_username" {
  description = "DockerHub username - required to avoid hitting Dockerhub API limits in EKS clusters"
  default     = ""
  type        = string
}

variable "dockerhub_password" {
  description = "DockerHub password - required to avoid hitting Dockerhub API limits in EKS clusters"
  default     = ""
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  default     = ""
  type        = string
}

variable "service_monitor" {
  description = "Enable ServiceMonitor for Prometheus Operator"
  default     = true
  type        = bool
}

variable "enable_trivy" {
  description = "Enable Trivy vulnerability scanner"
  default     = true
  type        = bool
}

variable "cluster_domain_name" {
  description = "The cluster domain used for iam_assumable_role_admin role name"
}

variable "eks_cluster_oidc_issuer_url" {
  description = "This is going to be used when we create the IAM OIDC role"
  type        = string
  default     = ""
}
