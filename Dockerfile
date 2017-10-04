FROM jenkinsci/slave

ENV PACKER_VERSION=1.0.4
ENV MAVEN_VERSION=3.5.0
ENV MAVEN_HOME=/usr/local/apache-maven-${MAVEN_VERSION}

USER root

# Install Git
RUN apt-get update && apt-get install -y git

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
RUN curl -L -o apache-maven-${MAVEN_VERSION}-bin.tar.gz http://mirror.jax.hugeserver.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    tar xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    mv apache-maven-${MAVEN_VERSION} ${MAVEN_HOME}; \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn
    

# Packer
RUN curl -L -o packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip; \
    unzip packer.zip; \
    mv packer /usr/local/bin/packer; \
    chmod +x /usr/local/bin/packer; \
    rm -f packer.zip

USER jenkins