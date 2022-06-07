################################################################
# Cosmosdb database exists :

az cosmosdb database exists `
    --db-name $CDBName `
    --name $CDBDatabaseAccount `
    --resource-group-name $RGName


################################################################
# Cosmosdb database list :

az cosmosdb database list `
    --name $CDBDatabaseAccount `
    --resource-group-name $RGName


################################################################
# Cosmosdb database list :

az cosmosdb database show 
    --db-name $CDBName 
    --name $CDBDatabaseAccount 
    --resource-group-name $RGName