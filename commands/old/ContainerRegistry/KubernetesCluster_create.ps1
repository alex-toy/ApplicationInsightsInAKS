"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Kubernetes Cluster :"

$Global:AKSCluster  = "alexeicluster"
"Cluster name  : "  + $AKSCluster 

$Global:AKSNodeCount = 2
"Node Count  : "  + $AKSNodeCount

$Global:AKSLocation = $RGLocation
"Node VM size  : "  + $AKSLocation

# standard_d15_v2 standard_ds15_v2 standard_e16bds_v5 
$Global:AKSNodeVMSize = "standard_d15_v2"
"Node VM size : "  + $AKSNodeVMSize


################################################################
"Create an Azure Kubernetes cluster configuration :"

az aks create `
    --name $AKSCluster `
    --resource-group $RGName `
    --node-count $AKSNodeCount `
    --generate-ssh-keys `
    --attach-acr $CRName `
    --location $AKSLocation `
    --node-vm-size $AKSNodeVMSize


################################################################
"Get credentials for your container service :"

$file = '.\commands\ContainerRegistry\aks_credentials.json'
az aks get-credentials `
    --name $AKSCluster `
    --resource-group $RGName | Out-File $file
  
$json = Get-Content $file -Raw | ConvertFrom-Json 

$Global:AKSKeys = $json.primaryMasterKey # to be improved
"AKS keys : " + $AKSKeys


################################################################
"Deploy function app to kubernetes :"

func kubernetes deploy `
    --name $functionApp `
    --registry $containerRegistry `
    --dry-run > deploy.yml

