"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Function App configuration :"

$Global:FAName = "alexeifa"
"Function App name : "  + $FAName

# python node
$Global:FARuntime = "python"
"Runtime : "  + $FARuntime

# Linux Windows
$Global:FAOSType = "Linux"
"OS Type : "  + $FAOSType

$Global:FAConsumptionPlanLocation = "eastus"
"Consumption plan location : "  + $FAConsumptionPlanLocation

$Global:FAFunctionVersion = 3
"Function version : "  + $FAFunctionVersion

$Global:FAKeyName = "alexeifakey"
"Key name : "  + $FAKeyName

$Global:FAKeyType = "functionKeys"
"Key type : "  + $FAKeyType


################################################################
"CREATE A FUNCTION APP :"

az functionapp create `
    --resource-group $RGName `
    --name $FAName `
    --runtime $FARuntime `
    --functions-version $FAFunctionVersion `
    --os-type $FAOSType `
    --consumption-plan-location $FAConsumptionPlanLocation `
    --functions-version 3 `
    --storage-account $SAName `
    # --plan MyPlan `



################################################################
"SET CONNECTION STRING :"

az functionapp config appsettings set `
    --name $FAName `
    --resource-group $RGName `
    --setting MyDbConnection=$CDBConnectionStrings
    # --settings "AzureWebJobsStorage=$CDBConnectionStrings"
    


################################################################
"SET KEYS FROM COSMOS DATABASE IF PREVIOUSLY CREATED :"

if($CDBKeys){
    az functionapp keys set `
        --resource-group $RGName `
        --name $FAName `
        --key-type $FAKeyType `
        --key-name $FAKeyName `
        --key-value $CDBKeys
}


#######################################################################
# Next step :

# $script = "commands\WebApp\WebApp_create.ps1"
# .$script





    