"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"VMSS configuration :"

$Global:VMSSName = "alexeivmss"
"VMSS name : "  + $VMSSName

$Global:VMSSImage = "UbuntuLTS"
"VMSS Image : "  + $VMSSImage

# Standard_DS1_v2 Standard_B1ls Standard_E16bds_v5 Standard_B1s
$Global:VMSSSKU = "Standard_B1s"
"SKU : "  + $Global:VMSSSKU

$Global:VMSSAdmin = "alexeiadmin"
"VMSS Admin user name : "  + $VMSSAdmin

# The password length must be between 12 and 72. 
# Password must have the 3 of the following: 
# 1 lower case character, 1 upper case character, 1 number and 1 special character.
$Global:VMSSPassword = "Alexeipw.1234"
"VMSS Admin Password : "  + $VMSSPassword

$Global:VMSSCustomData = "cloud-init.txt"
"VMSS Custom Data : "  + $VMSSCustomData

$Global:VMSSInstanceCount = 2
"VMSS Instance Count : "  + $VMSSInstanceCount

# Automatic, Manual, Rolling
$Global:VMSSUpgradePolicyMode = "Automatic"
"VMSS Upgrade Policy Mode : "  + $VMSSUpgradePolicyMode


################################################################
"LOAD BALANCER configuration :"

$Global:VMSSLoadBalancer = "alexeilb"
"VMSS Load Balancer : "  + $VMSSLoadBalancer


################################################################
"CREATE A VMSS :"

az vmss create `
    --resource-group $RGName `
    --name $VMSSName `
    --image $VMSSImage `
    --vm-sku $VMSSSKU `
    --custom-data $VMSSCustomData `
    --admin-username $VMSSAdmin `
    --upgrade-policy-mode $VMSSUpgradePolicyMode `
    --admin-password $VMSSPassword `
    --instance-count $VMSSInstanceCount `
    --load-balancer $VMSSLoadBalancer `
    # --public-ip-address-dns-name my-globally-dns-name `
    # --vnet-name MyVnet `
    # --subnet MySubnet `
    # --generate-ssh-keys
    # --admin-password


################################################################
"CREATE A NETWORK LOAD BALANCING RULE :"

$backendPoolName = (az network lb address-pool list `
    --lb-name $VMSSLoadBalancer `
    --resource-group $RGName | ConvertFrom-Json).name

$frontendIpName = (az network lb frontend-ip list `
    --resource-group $RGName `
    --lb-name $VMSSLoadBalancer  | ConvertFrom-Json).name

az network lb rule create `
    --resource-group $RGName `
    --name alexeinetworklbrule `
    --lb-name $VMSSLoadBalancer `
    --backend-pool-name $backendPoolName `
    --backend-port 80 `
    --frontend-ip-name $frontendIpName `
    --frontend-port 80 `
    --protocol Tcp

    # [--disable-outbound-snat {false, true}]
    # [--enable-tcp-reset {false, true}]
    # [--floating-ip {false, true}]
    # [--frontend-ip-name]
    # [--idle-timeout]
    # [--load-distribution {Default, SourceIP, SourceIPProtocol}]
    # [--probe-name]


$frontendIP = (az network public-ip show `
    --resource-group $RGName `
    --name "${VMSSLoadBalancer}PublicIP" | ConvertFrom-Json).ipAddress

"You can visit ${frontendIP}"

