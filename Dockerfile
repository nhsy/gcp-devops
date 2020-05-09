FROM alpine:latest

LABEL name=gcp-devops

ENV CLOUD_SDK_VERSION=291.0.0
ENV TERRAFORM_VERSION=0.12.24
ENV TERRAGRUNT_VERSION=0.23.10
ENV TERRAFORM_VALIDATOR_VERSION=2020-03-05
ENV CLOUDSDK_PYTHON=python3

ENV PATH /usr/lib/google-cloud-sdk/bin:$PATH
ENV TF_PLUGIN_CACHE_DIR=/opt/terraform/plugin-cache

RUN \
  apk --no-cache add \
    curl \
    python3 \
    py3-pip \
    py3-crcmod \
    bash \
    groff \
    less \
    libc6-compat \
    openssh-client \
    git \
    jq \
    vim \
    unzip \
    && \
  \
  pip3 install --upgrade pip && \
  \
  wget -q -O /tmp/google-cloud-sdk.tgz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf /tmp/google-cloud-sdk.tgz -C /usr/lib/ && \
  rm /tmp/google-cloud-sdk.tgz && \
  ln -s /lib /lib64 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image && \
  gcloud components install kubectl docker-credential-gcr --quiet

RUN \
  wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip /tmp/terraform.zip -d /tmp && \
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
  terraform version && \
  terragrunt -version && \
  terraform-validator version && \
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
  chmod -R 777 ${TF_PLUGIN_CACHE_DIR} && \
  rm ./terraform-providers.sh
