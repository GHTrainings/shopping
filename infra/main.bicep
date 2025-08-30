
// main.bicep - Azure App Service setup for shopping cart (frontend + backend)

param location string = 'UK West'
param appServicePlanName string = 'asp-shopping-cart'
param backendAppName string = 'shopping-backend-api'
param frontendAppName string = 'shopping-frontend-app'

var appServiceTier = 'Free'
var appServiceSize = 'F1'
var appServiceFamily = 'F'
var appServiceCapacity = 1
var dotnetEnvironment = 'Development'
var nodeEnvironment = 'production'
var nodeVersion = 'NODE|22-lts'
var appCommandLine = 'pm2 serve /home/site/wwwroot --no-daemon --spa'

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServiceSize // Free tier
    tier: appServiceTier
    size: appServiceSize
    family: appServiceFamily
    capacity: appServiceCapacity
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}


resource backend 'Microsoft.Web/sites@2022-09-01' = {
  name: backendAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: dotnetEnvironment
        }
      ]
  linuxFxVersion: 'DOTNET|9.0'
    }
  }
}


resource frontend 'Microsoft.Web/sites@2022-09-01' = {
  name: frontendAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'NODE_ENV'
          value: nodeEnvironment
        }
      ]
      linuxFxVersion: nodeVersion
      appCommandLine: appCommandLine
    }
  }
}


output backendAppUrl string = backend.properties.defaultHostName
output frontendAppUrl string = frontend.properties.defaultHostName
