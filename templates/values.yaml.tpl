trivy:
  
  # severity is a comma separated string list of CVE severity levels to monitor. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL
  severity: "${severity-level}"
  
  resources:
    requests:
      cpu: "${cpu_requests}"
      memory: "${memory_requests}"
    limits:
      cpu: "${cpu_limit}"
      memory: "${memory_limit}"
    
  # githubToken is the GitHub access token used by Trivy to download the vulnerabilities
  # database from GitHub. Only applicable in Standalone mode.

  # We are running clientServer mode, so not passing github access token
  # githubToken: "${github-access-token}"

operator:
  # Dockerhub credentials obtained via namespace secret
  scanJobsConcurrentLimit: ${job_concurrency_limit} 
  builtInTrivyServer: true
  privateRegistryScanSecretsNames: {"trivy-system":"dockerhub-credentials"}

serviceAccount:
  # Specifies whether a service account should be created.
  create: true
  annotations:
    "${role_key_annotation}": "${eks_service_account}"
  # name specifies the name of the k8s Service Account. If not set and create is
  # true, a name is generated using the fullname template.

  # ##########
  # An issue exists with builtInTrivyServer mode whereby the service account name is hardcoded:
  #
  # https://github.com/aquasecurity/trivy-operator/pull/692/files#diff-469d360fcbb4165cd38b47c205d92fe32006f484f92e124461a5d5bf1842c2bcR58
  #
  # This has been fixed in a feature due for release shortly:
  #
  # https://github.com/aquasecurity/trivy-operator/pull/692/files#diff-469d360fcbb4165cd38b47c205d92fe32006f484f92e124461a5d5bf1842c2bcR58
  #
  # For now, our service account name defaults to trivy-service-trivy-operator, which causes clientServer deployment to fail on service account lookup.
  # Testing workaround by setting serviceAccount.name to match hard-coded value, but this will trigger a tear down and full redeployment of trivy-operator:

  name: "trivy-operator"
  # ##########

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