variable "severity_list" {
  description = "A single string providing comma separated list of CVE Severity levels to be monitored. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL"
  default     = "UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL"
  type        = string
}
