################################################################
"CREATE A COSMOS COLLECTION :"

$collectionName = "mycollection"

az cosmosdb mongodb collection create `
    --account-name $CDBDatabaseAccount `
    --resource-group $RGName `
    --name $CDBName `
    -n $collectionName `
    --shard '_id' `
    --throughput $CDBThroughput `
    --idx @idxpolicy-$uniqueId.json




