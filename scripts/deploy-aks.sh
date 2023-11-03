#!/bin/bash

set -eu

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo " -h  Display this help message"
  echo " -r  Resource group"
  echo " -l  Resource group location"
  echo " -n  Name of the cluster"
}

main() {
  # Default variable values
  local resource_group=""
  local cluster_name=""
  local resource_group_location=""

  while getopts ":r:n:l:" option; do
    case $option in
      r)
        resource_group="${OPTARG}"
        ;;
      n)
        cluster_name="${OPTARG}"
        ;;
      l)
        resource_group_location="${OPTARG}"
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

  if [ -z "${resource_group_location}" ]; then
    echo "Resource group location is required"
    usage
    exit 1
  fi
  
  if [ -z "${cluster_name}" ]; then
    echo "Cluster name is required"
    usage
    exit 1
  fi

  # Create an Azure Resource Group (requires current credential to 
  # have subscription contribution permissions). In most production environments, resource
  # groups may already be created to minimize the permissions required. Bicep 
  # could be used to create the resource gorup as well.
  az group create --name "${resource_group}" --location "${resource_group_location}"
  
  # Deploy the Bicep template and capture the output to the variable `deploy_output`.
  # Deploying to a resource group requires the credential being used to have Contributor
  # rights in the Resource Group.
  deploy_output=$(az deployment group create --resource-group "${resource_group}" --template-file "aks.bicep" --parameters "clusterName=${cluster_name}" )
  
  # Parse deploy_output with jq to retrieve the control plan FQDN
  # Create an env variable to store the values.
  control_plane_fqdn=$(jq --raw-output '.properties.outputs.controlPlaneFQDN.value' <<< "$deploy_output")
  
  if [ -n "${GITHUB_OUTPUT}" ]; then
    # Create an output variable called control_plane_fqdn from the environment
    # variable of the same name. This makes the value available from other steps.
    echo "CONTROL_PLANE_FQDN=${control_plane_fqdn}" >> $GITHUB_OUTPUT
  
    # Create an output variable with the cluster name
    echo "CLUSTER_NAME=${cluster_name}" >> $GITHUB_OUTPUT
  fi
}

main "$@"
