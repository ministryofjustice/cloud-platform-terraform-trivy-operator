# trivy-operator requests is defined at top level
# we are ensuring operator is scheduled with suitable memory for live cluster

resources:
  requests:
    memory: 1500Mi

# -- excludeNamespaces is a comma separated list of namespaces (or glob patterns)
# to be excluded from scanning. Only applicable in the all namespaces install
# mode, i.e. when the targetNamespaces values is a blank string.
excludeNamespaces: "*smoketest*"

trivy:
  
  # severity is a comma separated string list of CVE severity levels to monitor. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL
  severity: "${severity_level}"

  # timeout is the duration to wait for scan completion.
  timeout: "${trivy_timeout}"

  server:
    securityContext:
      privileged: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
  
  resources:
    requests:
      cpu: "${cpu_requests}"
      memory: "${memory_requests}"
    limits:
      cpu: "${cpu_limit}"
      memory: "${memory_limit}"

  # command. One of `image`, `filesystem` or `rootfs` scanning, depending on the target type required for the scan.
  # For 'filesystem' and `rootfs` scanning, ensure that the `trivyOperator.scanJobPodTemplateContainerSecurityContext` is configured
  # to run as the root user (runAsUser = 0).
  command: rootfs
    
  # githubToken is the GitHub access token used by Trivy to download the vulnerabilities
  # database from GitHub. Only applicable in Standalone mode.
  githubToken:

operator:

  # scanJobTTL the set automatic cleanup time after the job is completed
  # scanJobTTL:

  # scanJobTimeout the length of time to wait before giving up on a scan job
  scanJobTimeout: ${scan_job_timeout}

  # scannerReportTTL the flag to set how long a report should exist. "" means that the ScannerReportTTL feature is disabled
  scannerReportTTL: "${scanner_report_ttl}"

  # configAuditScannerEnabled the flag to enable configuration audit scanner
  configAuditScannerEnabled: ${enable_config_audit}

  # rbacAssessmentScannerEnabled the flag to enable rbac assessment scanner
  rbacAssessmentScannerEnabled: ${enable_rbac_assess}

  # infraAssessmentScannerEnabled the flag to enable infra assessment scanner
  infraAssessmentScannerEnabled: ${enable_infra_assess}

  # clusterComplianceEnabled the flag to enable cluster compliance report generation 
  clusterComplianceEnabled: false

  # -- the flag to enable sbom generation
  sbomGenerationEnabled: false 

  # scanJobsConcurrentLimit the maximum number of scan jobs create by the operator
  scanJobsConcurrentLimit: ${job_concurrency_limit} 

  # builtInTrivyServer The flag enable the usage of built-in trivy server in cluster ,its also override the following trivy params with built-in values
  # trivy.mode = ClientServer and serverURL = http://<serverServiceName>.<trivy operator namespace>:4975 
  builtInTrivyServer: ${enable_trivy_server}

  # exposedSecretScannerEnabled the flag to enable exposed secret scanner
  exposedSecretScannerEnabled: ${enable_secret_scan}
  
  # Dockerhub credentials obtained via namespace secret
  # privateRegistryScanSecretsNames: {"trivy-system":"dockerhub-credentials"}

serviceAccount:
  # Specifies whether a service account should be created.
  create: true
  annotations:
    "${role_key_annotation}": "${eks_service_account}"
  # name specifies the name of the k8s Service Account. If not set and create is
  # true, a name is generated using the fullname template.
  name: "${trivy_service_account}"

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

trivyOperator:
  scanJobPodTemplateContainerSecurityContext:
    runAsUser: 0
    privileged: true
    allowPrivilegeEscalation: true
