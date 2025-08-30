
// main.bicep - Azure App Service setup for shopping cart (frontend + backend)
param location string = 'UK West'
param appServicePlanName string = 'asp-shopping-cart'
param backendAppName string = 'shopping-backend-api'
param frontendAppName string = 'shopping-frontend-app'

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F' // Free tier
    tier: 'Free'
  }
  kind: 'linux'
  properties: {
    reserved: true
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
          value: 'Production'
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
          value: 'production'
        }
      ]
      linuxFxVersion: 'NODE|22-lts'
    }
  }
}


output backendAppUrl string = backend.properties.defaultHostName
output frontendAppUrl string = frontend.properties.defaultHostName
