"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Cosmos database configuration :"

$Global:CDBName = "alexeicosmos"
"Cosmos database  : "  + $CDBName

$Global:CDBServerVersion = "4.0"
"Server Version  : "  + $CDBServerVersion

# Needs to be lower case
$Global:CDBDatabaseAccount = "alexeidatabaseaccount"
"CosmosDB Database Account : "  + $CDBDatabaseAccount

#GlobalDocumentDB, MongoDB, Parse
$Global:CDBKind = "MongoDB"
"Kind : "  + $CDBKind

$Global:CDBMaxThroughput = 4000
"Max Throughput : "  + $CDBMaxThroughput

$Global:CDBThroughput = 400
"Throughput : "  + $CDBThroughput

$Global:CDBCollectionName = 'myfirstcollection'
"Collection Name : "  + $CDBCollectionName

$Global:CDBDefaultConsistencyLevel = 'Eventual'
"Default consistency level : "  + $CDBDefaultConsistencyLevel

$Global:CDBenableAutomaticFailover = 'false'
"Enable automatic failover : "  + $CDBenableAutomaticFailover


################################################################
"CREATE A COSMOS DATABASE ACCOUNT :"

az cosmosdb create `
    --name $CDBDatabaseAccount `
    --resource-group $RGName `
    --kind $CDBKind `
    --server-version $CDBServerVersion `
    --default-consistency-level $CDBDefaultConsistencyLevel `
    --enable-automatic-failover $CDBenableAutomaticFailover
    # --subscription $Subscription



#######################################################################
# Next step :

# $script = "commands\CosmosDb\CosmosDb_proceed.ps1"
# .$script




