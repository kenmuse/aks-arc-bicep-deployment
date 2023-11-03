#!/bin/bash
set -eu

# Declare constants for version
declare -r HELMFILE_VERSION=0.158.1
declare -r HELMFILE_ARCH=amd64

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo " -h  Display this help message"
  echo " -r  Resource group"
  echo " -n  Name of the cluster"
}

# Function to install helmfile if it is not present
install_helmfile() {
  if [ -z "$(helmfile -v)" ]; then
    curl -Lo /tmp/helmfile.tar.gz https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_${HELMFILE_ARCH}.tar.gz
    tar --directory /tmp -xzvf /tmp/helmfile.tar.gz helmfile
    sudo install -m 755 /tmp/helmfile /usr/local/bin
  fi
}

main() {

  # Default variable values
  local resource_group=""
  local cluster_name=""

  while getopts ":r:n:" option; do
    case $option in
      r)
        resource_group="${OPTARG}"
        ;;
      n)
        cluster_name="${OPTARG}"
        ;;
      *)
        if [ -n "${OPTARG}" ]; then
          echo "Unknown argument: $OPTARG"
        fi
        usage
        exit 1
        ;;
    esac
  done
  
  if [ -z "${resource_group}" ]; then
    echo "Resource group is required"
    usage
    exit 1
  fi
  
  if [ -z "${cluster_name}" ]; then
    echo "Cluster name is required"
    usage
    exit 1
  fi
  
  # Install kubectl and kubelogin
  sudo az aks install-cli

  install_helmfile
  
  # Configure kubectl with the appropriate credentials
  az aks get-credentials --resource-group "${resource_group}" --name "${cluster_name}"
  
  ./helmfile init --force
  ./helmfile apply
}

main "$@"
