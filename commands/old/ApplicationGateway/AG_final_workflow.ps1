az network application-gateway frontend-port create `
    --resource-group $RGName `
    --name alexei-frontend-port `
    --gateway-name $AGName `
    --port 90

az network application-gateway http-listener create `
    --resource-group $RGName `
    --name $AGHTTPListener `
    --gateway-name $AGName `
    --frontend-port alexei-frontend-port

az network application-gateway http-settings create `
    --resource-group $RGName `
    --gateway-name $AGName `
    --name $AGHTTPSettings `
    --port 90 `
    --protocol Http

az network application-gateway rule create `
    --resource-group $RGName `
    --gateway-name $AGName `
    --http-listener $AGHTTPListener `
    --address-pool $AGAddressPool `
    --http-settings $AGHTTPSettings `
    --name alexei-rule-test 