param environment string
param accountName string
param location string

module cosmos './modules/cosmos.bicep' = {
  name: 'cosmosDeployment'
  params: {
    environment: environment
    accountName: accountName
    location: location
    databaseName: databaseName
    containerName: containerName
  }
}