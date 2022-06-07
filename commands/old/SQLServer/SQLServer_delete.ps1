################################################################
#DELETE RESOURCES :

#Delete DB
az sql db delete `
    --name $SQLBDName `
    --resource-group $ResourceGroupName `
    --server  $SQLServerName `
    --verbose

#Delete SQL Server
az sql server delete `
    --name  $SQLServerName `
    --resource-group $ResourceGroupName `
    --verbose



