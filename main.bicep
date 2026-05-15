param environment string
param accountName string
param location string
param freeTierEnabled bool

module cosmos './modules/cosmos.bicep' = {
  name: 'cosmosDeployment'
  params: {
    environment: environment
    accountName: accountName
    location: location
    freeTierEnabled: freeTierEnabled
  }
}