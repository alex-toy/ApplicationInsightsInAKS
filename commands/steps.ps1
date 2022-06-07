# Variables
$Global:resourceGroup="alexeirg"
$Global:location="francecentral"

az group create --name $resourceGroup --location $location

."commands\ContainerRegistry_create.ps1"

."commands\K8sCluster_create.ps1"

"Edit azure-vote-all-in-one-redis.yaml :"
"replace ${source}"
"with ${target}"
"Then run : commands\deployImages.ps1"

# ."commands\deployImages.ps1"

