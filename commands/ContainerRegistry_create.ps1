"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

# Variables
$Global:ACR="myacr202106"
$DockerImage = "azure-vote-front"
$Tag = "v1"

az acr create --resource-group $resourceGroup --name $ACR --sku Basic
az acr list -g $resourceGroup -o table
az acr login --name $ACR

# Find the login server address of your registry
az acr list -g $resourceGroup -o table

$Global:loginServerAddress = (az acr show `
    --name $ACR `
    --query loginServer --output table)[2]

"Associate a tag to the local image"
$Global:source = "mcr.microsoft.com/azuredocs/${DockerImage}:${Tag}"
$Global:target = "${loginServerAddress}/${DockerImage}:${Tag}"
docker tag $source $target

"Push the local registry to remote"
docker push "${loginServerAddress}/${DockerImage}:${Tag}"

"Verify if you image is up in the cloud :"
az acr repository list --name $loginServerAddress --output table