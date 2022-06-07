"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

# Variables
$AKS = "myAKSCluster"

# To ensure your cluster operates reliably, it is preferable to run at least 2 (two) nodes.
"Create a K8s cluster"
az aks create --name $AKS `
    --resource-group $resourceGroup `
    --node-count 1 `
    --enable-addons monitoring `
    --generate-ssh-keys `
    --attach-acr $ACR 

# To connect to the Kubernetes cluster from your local computer, you use kubectl, 
az aks install-cli

# Configure kubectl to connect to your Kubernetes cluster
az aks get-credentials --resource-group $resourceGroup --name $AKS

# Verify the connection to your cluster
kubectl get nodes





