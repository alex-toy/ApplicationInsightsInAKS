"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"CREATE AN APPLICATION GATEWAY :"

$Global:AGName = "alexeiag"
"AG Name : "  + $AGName

$Global:AGAddressPool = "vm-backend"
"AG Backend Address Pool : "  + $AGAddressPool

$Global:AGHTTPSettings = "http-settings"
"AG HTTP Settings : "  + $AGHTTPSettings

$Global:AGHTTPListener = "http-listener"
"AG AGHTTP Listener : "  + $AGHTTPListener

az network application-gateway create `
    --resource-group $RGName `
    --name $AGName `
    --vnet-name $VNETName `
    --subnet $SUBNET2Name `
    --public-ip-address ag-ip 

az network application-gateway address-pool create `
    --resource-group $RGName `
    --gateway-name $AGName `
    --name $AGAddressPool `
    --servers $IP1 $IP2

$rule = az network application-gateway rule list `
    --resource-group $RGName `
    --gateway-name $AGName | ConvertFrom-Json | Foreach-Object { $_.name }

az network application-gateway rule update `
    --resource-group $RGName `
    --gateway-name $AGName `
    --name $rule `
    --address-pool $AGAddressPool

