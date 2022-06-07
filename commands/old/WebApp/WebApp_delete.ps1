################################################################
#DELETE RESOURCES :

#Delete an App Service
az webapp delete `
    --name $WAName `
    --resource-group $RGName


#Delete an App Service plan
az appservice plan delete `
    --name [App Service Plan Name] `
    --resource-group $RGName