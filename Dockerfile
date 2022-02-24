FROM jenkins:jdk-11.9
USER root
RUN apt-get update -y & apt-get install docker.io vim

# copy kubernetes config to jenkins container
COPY ./config /root/.kube/config

# install kubectl
RUN 
