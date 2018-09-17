{{ with secret "pki/issue/ROLE_NAME" "common_name=DOCKER_HOST_NAME" "ip_sans=DOCKER_HOST_IP" }}{{ .Data.certificate }}
{{ .Data.issuing_ca }}{{ end }}
