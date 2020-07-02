FROM alpine:latest

LABEL name=gcp-devops

ARG GCLOUD_VERSION=298.0.0
ARG PACKER_VERSION=1.6.0
ARG TERRAFORM_VERSION=0.12.28
ARG TERRAGRUNT_VERSION=0.23.29
ARG TERRAFORM_VALIDATOR_VERSION=2020-03-05

ENV CLOUDSDK_PYTHON=python3
ENV PATH /usr/lib/google-cloud-sdk/bin:$PATH
ENV TF_PLUGIN_CACHE_DIR=/opt/terraform/plugin-cache

RUN \
  apk --no-cache add \
    ansible \
    bash \
    bash-completion \
    curl \
    groff \
    git \
    jq \
    less \
    libc6-compat \
    make \
    openssh-client \
    python3 \
    py3-pip \
    py3-crcmod \
    tree \
    vim \
    wget \
    unzip \
    && \
  \
  pip3 install --upgrade pip && \
  \
  wget -q -O /tmp/google-cloud-sdk.tgz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
  tar xzf /tmp/google-cloud-sdk.tgz -C /usr/lib/ && \
  rm /tmp/google-cloud-sdk.tgz && \
  ln -s /lib /lib64 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image && \
  gcloud components install kubectl docker-credential-gcr --quiet && \
  \
  # Cleanup \
  rm -rf /tmp/* && \
  rm -rf /var/cache/apk/* && \
  rm -rf /var/tmp/*

RUN \
  wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip -q /tmp/terraform.zip -d /tmp && \
  chmod +x /tmp/terraform && \
  mv /tmp/terraform /usr/local/bin && \
  \
  wget -q -O /tmp/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
  chmod +x /tmp/terragrunt && \
  mv /tmp/terragrunt /usr/local/bin && \
  \
  gsutil cp gs://terraform-validator/releases/${TERRAFORM_VALIDATOR_VERSION}/terraform-validator-linux-amd64 /tmp/terraform-validator && \
  chmod +x /tmp/terraform-validator && \
  mv /tmp/terraform-validator /usr/local/bin && \
  \
  wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
  unzip -q /tmp/packer.zip -d /tmp && \
  chmod +x /tmp/packer && \
  mv /tmp/packer /usr/local/bin && \
  \
  ansible --version && \
  terraform version && \
  terragrunt -version && \
  terraform-validator version && \
  packer version

# Customisations
COPY *.sh /tmp/
RUN \
  adduser -Ds /bin/bash devops && \
  \
  mkdir -p ${TF_PLUGIN_CACHE_DIR}/linux_amd64 && \
  . /tmp/10-terraform-providers.sh && \
  chmod -R 777 ${TF_PLUGIN_CACHE_DIR} && \
  \
  . /tmp/20-bashrc.sh && \
  \
  # Cleanup \
  rm -rf /tmp/* && \
  rm ~/.wget-hsts

ENTRYPOINT ["/bin/bash"]
