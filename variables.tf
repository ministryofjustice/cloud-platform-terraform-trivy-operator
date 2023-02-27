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

variable "service_monitor_enabled" {
  description = "Enable ServiceMonitor for Prometheus Operator"
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

variable "role_key_annotation" {
  description = "The annotation key to use for the role key"
  default     = "eks.amazonaws.com/role-arn"
  type        = string
}

variable "memory_limit" {
  description = "resources:limit memory value"
  default     = "500M"
  type        = string
}

variable "cpu_limit" {
  description = "resources:limits CPU value"
  default     = "500m"
  type        = string
}

variable "memory_requests" {
  description = "resources:requests memory value"
  default     = "100M"
  type        = string
}

variable "cpu_requests" {
  description = "resources:requests CPU value"
  default     = "100m"
  type        = string
}

variable "memory_limit_non_live" {
  description = "Non-live cluster value for resources:limit memory value"
  default     = "500M"
  type        = string
}

variable "cpu_limit_non_live" {
  description = "Non-live cluster value for resources:limits CPU value"
  default     = "500m"
  type        = string
}

variable "memory_requests_non_live" {
  description = "Non-live clustrer value for resources:requests memory value"
  default     = "100M"
  type        = string
}

variable "cpu_requests_non_live" {
  description = "Non-live cluster value for resources:requests CPU value"
  default     = "100m"
  type        = string
}

variable "job_concurrency_limit" {
  description = "Sets the maximum value for concurrent report jobs"
  default     = 5
  type        = number
}

variable "scan_job_timeout" {
  description = "The length of time to wait before giving up on a scan job"
  default     = "5m"
  type        = string
}

variable "enable_trivy_server" {
  description = "Enable built-in trivy server (clientServer mode). If true, do not set githubToken value"
  default     = "false"
  type        = string
}

variable "trivy_service_account" {
  description = "Name of the k8s Service Account. If not set, name is generated automatically."
  default     = ""
  type        = string
}
