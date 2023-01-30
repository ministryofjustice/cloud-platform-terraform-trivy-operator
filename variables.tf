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
