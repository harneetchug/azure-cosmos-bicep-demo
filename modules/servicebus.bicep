param location string = 'francecentral'
param serviceBusName string
param queueName string = 'customer-events'

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    minimumTlsVersion: '1.2'
  }
}

resource queue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  name: queueName
  parent: sbNamespace

  properties: {
    enablePartitioning: true
  }
}