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

  resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
    name: '${accountName.name}/${databaseName}'

    properties: {
      resource: {
        id: databaseName
      }
    }

    dependsOn: [
      accountName
    ]
  }
}

resource sqlContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: '${cosmosAccount.name}/${databaseName}/${containerName}'

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

  dependsOn: [
    sqlDatabase
  ]
}