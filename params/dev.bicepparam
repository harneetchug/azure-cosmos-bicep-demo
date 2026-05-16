using '../cosmos-main.bicep'
using '../logicapp.bicep'

param environment = 'dev'
param accountName = 'cosmos-acc-bicep'
param location = 'francecentral'
param databaseName='customerdb'
param containerName='customerdetails'
param logicAppName='harlogicAppName'