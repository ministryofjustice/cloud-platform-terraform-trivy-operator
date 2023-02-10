trivy:
  
  # severity is a comma separated string list of CVE severity levels to monitor. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL
  severity: "${severity-level}"
    
  # githubToken is the GitHub access token used by Trivy to download the vulnerabilities
  # database from GitHub. Only applicable in Standalone mode.
  githubToken: "${github-access-token}"

operator:
  # Dockerhub credentials obtained via namespace secret
  privateRegistryScanSecretsNames: {"trivy-system":"dockerhub-credentials"}

serviceAccount:
  # Specifies whether a service account should be created.
  create: true
  annotations:
    "${role_key_annotation}": "${eks_service_account}"
  # name specifies the name of the k8s Service Account. If not set and create is
  # true, a name is generated using the fullname template.
  name: ""

# Prometheus ServiceMonitor configuration -- to install the trivy operator with the ServiceMonitor
# you must have Prometheus already installed and running
serviceMonitor:
  # enabled determines whether a serviceMonitor should be deployed
  enabled: ${service_monitor_enabled}
  # The namespace where Prometheus expects to find service monitors
  # namespace: ""
  interval: ""
  # Additional labels for the serviceMonitor
  labels: {}
  # honorLabels: true

resources:
  requests:
    cpu: "500m"
    memory: "512Mi"
  limits:
    cpu: "1"
    memory: "1Gi"