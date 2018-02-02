FROM jenkinsci/slave
# Based on Debian

ARG VAULT_URL
ENV PACKER_VERSION=1.0.4
ENV MAVEN_VERSION=3.5.2
ENV TERRAFORM_VERSION=0.11.3
ENV MAVEN_HOME=/usr/local/apache-maven-${MAVEN_VERSION}
ENV VAULT_ADDR=$VAULT_URL

USER root

# Install Git
RUN apt-get update && apt-get install -y git jq

# Install AWS CLI
RUN apt-get install -y python3; \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"; \
    unzip awscli-bundle.zip; \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws


# Install Docker Prereqs
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common; \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -; \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) \
        stable"; \
    apt-get update && apt-get install -y \
        docker-ce; \
    systemctl disable docker; \
	rm -rf /var/lib/apt/lists/*

# Install Maven
RUN curl -s -L -o apache-maven-${MAVEN_VERSION}-bin.tar.gz http://mirror.jax.hugeserver.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    tar xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    mv apache-maven-${MAVEN_VERSION} ${MAVEN_HOME}; \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn
    

# Packer
RUN curl -s -L -o packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip; \
    unzip packer.zip; \
    mv packer /usr/local/bin/packer; \
    chmod +x /usr/local/bin/packer; \
    rm -f packer.zip

# Terraform
RUN curl -s -L -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
    unzip terraform.zip; \
    mv terraform /usr/local/bin/terraform; \
    chmod +x /usr/local/bin/terraform; \
    rm -f terraform.zip

# Vault Certificates
RUN mkdir /usr/local/share/ca-certificates/ascent; \
    echo "Downloading Vault CA certificate from $VAULT_ADDR/v1/pki/ca/pem"; \
    mkdir -p /usr/local/share/ca-certificates/vault/; \
    curl -L -s --insecure ${VAULT_ADDR}/v1/pki/ca/pem > /usr/local/share/ca-certificates/vault/vault-ca.crt; \
    update-ca-certificates

USER jenkins