"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"SQL database configuration :"

$Global:SQLAdminUser = "alexadmin"
"SQL admin user : "  + $SQLAdminUser

$Global:SQLAdminPassword = "p@ssword1234"
"SQL Admin password : " + $SQLAdminPassword

$Global:SQLServerName = "flask-sql-server"
"SQL server name : " + $SQLServerName

$Global:SQLLocation = "francecentral"
"SQL Location : " + $SQLLocation

$Global:SQLEnablePublicNetwork = "true"
"SQL enable public network : " + $SQLEnablePublicNetwork

$Global:SQLBDName = "flask-db"
"DB name : " + $SQLBDName

$Global:FirewallRuleName = "azureaccess"
"Firewall Rule Name : " + $FirewallRuleName

$Global:ClientIPFirewallRuleName = "clientip"
"ClientIP Firewall Rule Name : " + $ClientIPFirewallRuleName

$Global:Tier = "Basic"
"Tier : " + $Tier



#######################################################################
"Set config file :"

$file = ".\commands\Configs\var.cfg"

(Get-Content -Path $file) | ForEach-Object { 
    if($_.split("=")[0] -like 'SQL_*') {
        $new = $_.split("=")[0]; $new
    } else {
        $_
    }
} | Set-Content -Path $file

(Get-Content -Path $file) | ForEach-Object { $rep = 'SQL_SERVER=' + $SQLServerName; $_ -Replace 'SQL_SERVER', $rep } | Set-Content -Path $file
(Get-Content -Path $file) | ForEach-Object { $rep = 'SQL_DATABASE=' + $SQLBDName; $_ -Replace 'SQL_DATABASE', $rep } | Set-Content -Path $file
(Get-Content -Path $file) | ForEach-Object { $rep = 'SQL_USER_NAME=' + $SQLAdminUser; $_ -Replace 'SQL_USER_NAME', $rep } | Set-Content -Path $file
(Get-Content -Path $file) | ForEach-Object { $rep = 'SQL_PASSWORD=' + $SQLAdminPassword; $_ -Replace 'SQL_PASSWORD', $rep } | Set-Content -Path $file



################################################################
"CREATE SQL SERVER :"

az sql server create `
    --admin-user $SQLAdminUser `
    --admin-password $SQLAdminPassword `
    --name $SQLServerName `
    --resource-group $RGName `
    --location $RGLocation `
    --enable-public-network $SQLEnablePublicNetwork `
    --verbose


################################################################
"CREATE FIREWALL RULES :"

#allow Allow Azure services and resources to access the server we just created.
az sql server firewall-rule create `
    -g $RGName `
    -s $SQLServerName `
    -n $FirewallRuleName `
    --start-ip-address 0.0.0.0 `
    --end-ip-address 0.0.0.0 `
    --verbose


################################################################
"RETRIEVE LOCAL IP ADDRESS :"

$Global:LocalPublicIP = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
"Local Public IP : " + $LocalPublicIP


################################################################
"LAST SETTINGS :"

#set your computer's public Ip address to the server's firewall
az sql server firewall-rule create `
    -g $RGName `
    -s $SQLServerName `
    -n $ClientIPFirewallRuleName `
    --start-ip-address $LocalPublicIP `
    --end-ip-address $LocalPublicIP `
    --verbose

#create the database itself
az sql db create `
    --name $SQLBDName `
    --resource-group $RGName `
    --server $SQLServerName `
    --tier Basic `
    --verbose


#######################################################################
# Next step :

"Now run : starter\script\script.sql in the azure SQL console to create the tables, then run commands\StorageAccount\StorageAccount_create.ps1"




