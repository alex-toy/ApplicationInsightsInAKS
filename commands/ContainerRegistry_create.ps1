"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

# Variables
$ACR = "alexeiacr2"

az acr create --resource-group $resourceGroup --name $ACR --sku Basic
# Log in to the ACR
az acr login --name $ACR
# Get the ACR login server name
# To use the azure-vote-front container image with ACR, the image needs to be tagged with the login server address of your registry. 
# Find the login server address of your registry
az acr show --name $ACR --query loginServer --output table
# Associate a tag to the local image
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 "${ACR}.azurecr.io/azure-vote-front:v1"
# Now you will see myacr202106.azurecr.io/azure-vote-front:v1 if you run docker images
# Push the local registry to remote
docker push "${ACR}.azurecr.io/azure-vote-front:v1"
# Verify if you image is up in the cloud.
az acr repository list --name "${ACR}.azurecr.io" --output table


