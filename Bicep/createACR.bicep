// ACR
@minLength(5)
@maxLength(50)
@description('Provide a unique name for Azure Container Registry (or let it autogenerate)')
param acrName string = 'acr${uniqueString(resourceGroup().id)}'
@description('Provide a tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Basic'

// Global values
@description('Leave this as-is, for all resources to be created in the same locaiton as the resource group.')
param location string   = resourceGroup().location

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}

@description('Output the login server property for later use')
output loginServer string = acrResource.properties.loginServer

// az group create --name MyContainerRegRG --location westus
// az deployment group create --name MyContainerDeploy --resource-group MyContainerRegRG --template-file createACR.bicep --parameters createACR.bicepparam
