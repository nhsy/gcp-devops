FROM alpine:latest

LABEL name=gcp-devops

ENV CLOUD_SDK_VERSION 289.0.0
ENV TERRAFORM_VERSION=0.12.24
ENV TERRAGRUNT_VERSION=0.23.10
ENV HELM_VERSION=3.0.2
ENV TERRAFORM_VALIDATOR_VERSION=2020-03-05
ENV CLOUDSDK_PYTHON=python3

ENV PATH /usr/lib/google-cloud-sdk/bin:$PATH
ENV TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache

WORKDIR /root

RUN \
  apk --no-cache add \
    curl \
    python3 \
    py3-pip \
    py3-crcmod \
    bash \
    libc6-compat \
    openssh-client \
    git \
    jq \
    vim \
    unzip && \
  \
  wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz -C /usr/lib/ && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  ln -s /lib /lib64 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image && \
  gcloud components install kubectl docker-credential-gcr --quiet && \
  \
  wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/bin && \
  rm -rf linux-amd64 && \
  rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  \
  wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mv terraform /usr/bin && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  \
  wget -q https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
  chmod +x terragrunt_linux_amd64 && \
  mv terragrunt_linux_amd64 /usr/bin/terrgrunt && \
  \
  gsutil cp gs://terraform-validator/releases/${TERRAFORM_VALIDATOR_VERSION}/terraform-validator-linux-amd64 . && \
  chmod +x terraform-validator-linux-amd64 && \
  mv terraform-validator-linux-amd64 /usr/bin/terraform-validator && \
  \
  # Cleanup \
  rm -rf /tmp/* && \
  rm -rf /var/cache/apk/* && \
  rm -rf /var/tmp/*

# Cache terraform providers
COPY terraform-providers.sh .
RUN \
  mkdir -p ${TF_PLUGIN_CACHE_DIR}/linux_amd64 && \
  chmod +x ./terraform-providers.sh && \
  ./terraform-providers.sh && \
  rm ./terraform-providers.sh
