vault {
  renew_token   = false
  unwrap_token = false

  retry {
    attempts = 10
  }

  ssl {
    enabled = true
    verify  = false
  }
}

template {
  source = "/tmp/templates/ca.crt.tpl"
  destination = "/var/lib/jenkins/docker-certs/[CA_FILE_NAME]_ca.crt"
  perms = 0644
}

template {
  source = "/tmp/templates/docker_swarm.crt.tpl"
  destination = "/var/lib/jenkins/docker-certs/[CERT_FILE_NAME].crt"
  perms = 0644
}

template {
  source = "/tmp/templates/docker_swarm.key.tpl"
  destination = "/var/lib/jenkins/docker-certs/[CERT_FILE_NAME].key"
  perms = 0644
}
