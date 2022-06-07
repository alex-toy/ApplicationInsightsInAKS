################################################################
"CREATE A CONTAINER REGISTRY :"

az acr login --name $CRName
# Both these commands will give a same result
az acr show --name $CRName --query loginServer --output table
az acr list --resource-group $RGName --query "[].{acrLoginServer:loginServer}" --output table

# View the newly pushed image in the ACR respository
az acr repository list --name $CRName --output table

