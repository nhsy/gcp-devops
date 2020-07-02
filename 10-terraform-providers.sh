#!/bin/bash
set -e

for version in 3.19.0 3.20.0 3.27.0
do
  echo "Downloading google provider version: $version"
  wget -q https://releases.hashicorp.com/terraform-provider-google/${version}/terraform-provider-google_${version}_linux_amd64.zip
  unzip terraform-provider-google_${version}_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
  rm terraform-provider-google_${version}_linux_amd64.zip

  wget -q https://releases.hashicorp.com/terraform-provider-google-beta/${version}/terraform-provider-google-beta_${version}_linux_amd64.zip
  unzip terraform-provider-google-beta_${version}_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
  rm terraform-provider-google-beta_${version}_linux_amd64.zip
done

wget -q https://releases.hashicorp.com/terraform-provider-random/2.2.1/terraform-provider-random_2.2.1_linux_amd64.zip
unzip terraform-provider-random_2.2.1_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-random_2.2.1_linux_amd64.zip

wget -q https://releases.hashicorp.com/terraform-provider-template/2.1.2/terraform-provider-template_2.1.2_linux_amd64.zip
unzip terraform-provider-template_2.1.2_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-template_2.1.2_linux_amd64.zip

wget -q https://releases.hashicorp.com/terraform-provider-null/2.1.2/terraform-provider-null_2.1.2_linux_amd64.zip
unzip terraform-provider-null_2.1.2_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-null_2.1.2_linux_amd64.zip

wget -q https://releases.hashicorp.com/terraform-provider-tls/2.1.1/terraform-provider-tls_2.1.1_linux_amd64.zip
unzip terraform-provider-tls_2.1.1_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-tls_2.1.1_linux_amd64.zip

wget -q https://releases.hashicorp.com/terraform-provider-local/1.4.0/terraform-provider-local_1.4.0_linux_amd64.zip
unzip terraform-provider-local_1.4.0_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-local_1.4.0_linux_amd64.zip

wget -q https://releases.hashicorp.com/terraform-provider-http/1.2.0/terraform-provider-http_1.2.0_linux_amd64.zip
unzip terraform-provider-http_1.2.0_linux_amd64.zip -d "${TF_PLUGIN_CACHE_DIR}"/linux_amd64
rm terraform-provider-http_1.2.0_linux_amd64.zip
