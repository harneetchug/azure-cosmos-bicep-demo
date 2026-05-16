param location string = 'francecentral'

param logicAppName string

param accountName string
param databaseName string
param containerName string

@description('Cosmos DB endpoint')
param cosmosEndpoint string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location

  properties: {
    state: 'Enabled'

    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'

      contentVersion: '1.0.0.0'

      parameters: {
        cosmosEndpoint: {
          type: 'String'
        }
      }

      triggers: {
        HttpTrigger: {
          type: 'Request'
          kind: 'Http'

          inputs: {
            schema: {
              type: 'object'

              properties: {
                id: {
                  type: 'string'
                }

                customerId: {
                  type: 'string'
                }

                name: {
                  type: 'string'
                }
              }

              required: [
                'id'
                'customerId'
              ]
            }
          }
        }
      }

      actions: {

        BuildDocument: {
          type: 'Compose'

          inputs: {
            id: '@triggerBody()?[\'id\']'
            customerId: '@triggerBody()?[\'customerId\']'
            name: '@triggerBody()?[\'name\']'
          }
        }

        WriteToCosmos: {
          type: 'Http'

          inputs: {
            method: 'POST'

            uri: '[concat(parameters(''cosmosEndpoint''), ''/dbs/${databaseName}/colls/${containerName}/docs'')]'

            headers: {
              'Content-Type': 'application/json'
              'x-ms-documentdb-is-upsert': 'true'
            }

            body: '@outputs(''BuildDocument'')'
          }
        }

        Response: {
          type: 'Response'

          inputs: {
            statusCode: 200

            body: {
              message: 'Document inserted into Cosmos DB'
              id: '@triggerBody()?[\'id\']'
            }
          }
        }
      }
    }
}