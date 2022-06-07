"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"POSTGRES SQL database configuration :"

$Global:SQLAdminUser = "alexadmin"
"SQL admin user : "  + $SQLAdminUser

$Global:SQLAdminPassword = "p@ssword1234"
"SQL Admin password : " + $SQLAdminPassword

$Global:SQLServerName = "migration-sql-server"
"SQL server name : " + $SQLServerName

$Global:SQLLocation = "francecentral"
"SQL Location : " + $SQLLocation

$Global:SQLEnablePublicNetwork = "true"
"SQL enable public network : " + $SQLEnablePublicNetwork

$Global:SQLBDName = "migration-db"
"DB name : " + $SQLBDName

$Global:FirewallRuleName = "azureaccess"
"Firewall Rule Name : " + $FirewallRuleName

$Global:ClientIPFirewallRuleName = "clientip"
"ClientIP Firewall Rule Name : " + $ClientIPFirewallRuleName

$Global:Tier = "Basic"
"Tier : " + $Tier



################################################################
"CREATE POSTGRES SQL SERVER :"

az postgres server create `
    --resource-group $RGName `
    --location $RGLocation `
    --name $SQLServerName `
    --admin-user $SQLAdminUser `
    --admin-password $SQLAdminPassword `
    --version 11 `
    --storage-size 5120 `
    --verbose

    # [--assign-identity]
    # [--auto-grow {Disabled, Enabled}]
    # [--backup-retention]
    # [--geo-redundant-backup {Disabled, Enabled}]
    # [--infrastructure-encryption {Disabled, Enabled}]
    # [--minimal-tls-version {TLS1_0, TLS1_1, TLS1_2, TLSEnforcementDisabled}]
    # [--public]
    # [--sku-name]
    # [--ssl-enforcement {Disabled, Enabled}]
    # [--tags]


################################################################
"CREATE FIREWALL RULES :"

#allow Allow Azure services and resources to access the server we just created.
az postgres server firewall-rule create `
    --resource-group $RGName `
    --name $FirewallRuleName `
    --server-name  $SQLServerName `
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
az postgres server firewall-rule create `
    --resource-group $RGName `
    --server-name  $SQLServerName `
    --name $FirewallRuleName `
    --start-ip-address $LocalPublicIP `
    --end-ip-address $LocalPublicIP `
    --verbose

"create the database itself"
az postgres db create `
    --name $SQLBDName `
    --resource-group $RGName `
    --server-name $SQLServerName


# az sql db create `
# --name $SQLBDName `
# --resource-group $RGName `
# --server $SQLServerName `
# --tier Basic `
# --verbose