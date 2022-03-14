FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt-get update && apt-get install -y docker.io vim curl

# copy kubernetes config to jenkins container
COPY ./config /root/.kube/config

# install kubectl
RUN  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# RUN `echo "$(<kubectl.sha256)  kubectl" | sha256sum --check`
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# install node (for frontend)
ENV NODE_VERSION=16.13.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# install python (for backend)
RUN apt install python3 -y
RUN apt install python3-pip -y
RUN apt install libpq-dev python3-dev




