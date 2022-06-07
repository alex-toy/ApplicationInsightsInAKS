"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"CREATE A VNET :"

$Global:VNETName = "alexeivnet"
"VNET Name : "  + $VNETName

$Global:SUBNET1Name = "vm-subnet"
"SUBNET 1 Name : "  + $SUBNET1Name

$Global:SUBNET2Name = "ag-subnet"
"SUBNET 2 Name : "  + $SUBNET2Name

az network vnet create `
    --resource-group $RGName `
    --location $RGLocation `
    --name $VNETName `
    --address-prefixes 10.1.0.0/16 `

az network vnet subnet create `
    --resource-group $RGName `
    --vnet-name $VNETName `
    --name $SUBNET1Name `
    --address-prefixes 10.1.1.0/24 

az network vnet subnet create `
    --resource-group $RGName `
    --vnet-name $VNETName `
    --name $SUBNET2Name `
    --address-prefixes 10.1.2.0/24 



################################################################
"CREATE VM1 :"

$Global:VM1Name = "alexeivm1"
"VM1 Name : "  + $VM1Name

$Global:VM1AdminUsername = "alexei"
"VM1 Admin User name : "  + $VM1AdminUsername

az vm create `
    --resource-group $RGName `
    --name $VM1Name `
    --subnet $SUBNET1Name `
    --vnet-name $VNETName `
    --image UbuntuLTS `
    --generate-ssh-keys `
    --public-ip-address VM1-publicIP `
    --admin-username $VM1AdminUsername `
    --custom-data cloud-init.txt `
    --admin-password Alexei.80.VM

$Global:IP1 = (az vm list-ip-addresses `
    -g $RGName `
    -n $VM1Name | ConvertFrom-Json).virtualMachine.network.publicIpAddresses.ipAddress
"VM1 IP : ${IP1}"



################################################################
"CREATE VM2 :"

$Global:VM2Name = "alexeivm2"
"VM2 Name : "  + $VM2Name

$Global:VM2AdminUsername = "alexei"
"VM2 Admin User name : "  + $VM2AdminUsername

az vm create `
    --resource-group $RGName `
    --name $VM2Name `
    --subnet $SUBNET1Name `
    --vnet-name $VNETName `
    --image UbuntuLTS `
    --generate-ssh-keys `
    --public-ip-address VM2-publicIP `
    --admin-username $VM2AdminUsername `
    --custom-data cloud-init.txt `
    --admin-password Alexei.80.VM

$Global:IP2 = (az vm list-ip-addresses `
    -g $RGName `
    -n $VM2Name | ConvertFrom-Json).virtualMachine.network.publicIpAddresses.ipAddress
    
"VM2 IP : ${IP2}"





    























    