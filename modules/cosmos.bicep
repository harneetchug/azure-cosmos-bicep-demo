param environment string
param accountName string
param location string
param freeTierEnabled bool

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'

  tags: {
    environment: environment
    owner: 'harneet-team'
  }

  properties: {
    databaseAccountOfferType: 'Standard'

    freeTierEnabled: freeTierEnabled

    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]

    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}