az acr create --resource-group myResourceGroup --name myacr202106 --sku Basic
# Log in to the ACR
az acr login --name myacr202106
# Get the ACR login server name
# To use the azure-vote-front container image with ACR, the image needs to be tagged with the login server address of your registry. 
# Find the login server address of your registry
az acr show --name myacr202106 --query loginServer --output table
# Associate a tag to the local image
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 myacr202106.azurecr.io/azure-vote-front:v1
# Now you will see myacr202106.azurecr.io/azure-vote-front:v1 if you run docker images
# Push the local registry to remote
docker push myacr202106.azurecr.io/azure-vote-front:v1
# Verify if you image is up in the cloud.
az acr repository list --name myacr202106.azurecr.io --output table



