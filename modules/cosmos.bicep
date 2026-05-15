param environment string
param accountName string
param location string
param databaseName string
param containerName string

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'

  tags: {
    environment: environment
  }

  properties: {
    databaseAccountOfferType: 'Standard'

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

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: databaseName
  parent: cosmos

  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: containerName
  parent: database

  properties: {
    resource: {
      id: containerName

      partitionKey: {
        paths: [
          '/customerId'
        ]
        kind: 'Hash'
      }
    }

    options: {
      throughput: 400
    }
  }
}