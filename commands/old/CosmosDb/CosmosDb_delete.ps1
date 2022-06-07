################################################################
#DELETE ALL RESOURCES :

az cosmosdb database delete `
    --db-name $CDBName `
    --name $CDBDatabaseAccount `
    --resource-group-name $RGName


    