# Set severity monitoring levels

trivy:

  # severity is a comma separated string list of CVE severity levels to monitor. Possible values are UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL
  
  severity: "${severity-level}"

  # githubToken is the GitHub access token used by Trivy to download the vulnerabilities
  # database from GitHub. Only applicable in Standalone mode.
  
  githubToken: "${github-access-token}"