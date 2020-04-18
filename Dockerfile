FROM alpine:latest

LABEL name=gcp-devops

ENV CLOUD_SDK_VERSION 289.0.0
ENV TERRAFORM_VERSION=0.12.24
ENV HELM_VERSION=3.0.2
ENV TERRAFORM_VALIDATOR_VERSION=2020-03-05
ENV CLOUDSDK_PYTHON=python3

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        curl \
        python3 \
        py3-pip \
        py3-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        jq \
        vim

RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  ln -s /lib /lib64 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image && \
  gcloud components install kubectl && \
  gcloud components install docker-credential-gcr --quiet

RUN wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/bin && \
  rm -rf linux-amd64

RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mv terraform /usr/bin && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN gsutil cp gs://terraform-validator/releases/${TERRAFORM_VALIDATOR_VERSION}/terraform-validator-linux-amd64 . && \
  chmod +x terraform-validator-linux-amd64 && \
  mv terraform-validator-linux-amd64 /usr/bin/terraform-validator

# Cleanup
RUN rm -rf /tmp/* && \
  rm -rf /var/cache/apk/* && \
  rm -rf /var/tmp/*
