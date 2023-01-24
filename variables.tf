variable "severity" {
  default = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]
}

variable "ignore_unfixed" {
  default = true
}
