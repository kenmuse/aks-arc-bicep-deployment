@description('The name of the Managed Cluster resource.')
param clusterName string

@description('The name of the Managed Cluster resource.')
param dnsPrefix string = '${clusterName}-dns'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

resource aks 'Microsoft.ContainerService/managedClusters@2023-07-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  properties: {
    kubernetesVersion: '1.27.3'
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        osSKU: 'Ubuntu'
        enableAutoScaling: true
        enableUltraSSD: false
        count: 1
        minCount: 1
        maxCount: 3
        type: 'VirtualMachineScaleSets'
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
