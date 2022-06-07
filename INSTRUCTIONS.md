Application Insights in AKS
=
Create an AKS cluster with App Insights enabled Verify information is being collected and displayed properly. We will deploy a frontend Flask application to the AKS cluster as a multi-container application.


## About the application: 
It is a Flask application, a basic voting app, consisting of a front-end web component and a back-end Redis instance. The frontend application code is present in the azure-vote/azure-vote directory. It connects to a Redis database instance. You can run the application in two ways:
- **Locally using the Docker containers**: Under this option, the frontend will be packaged into a custom container image. The Redis instance uses an unmodified image from Docker Hub. We will use docker-compose.yaml here to create images, and run the application locally using Docker.
- **Deploy the application images to the AKS cluster**: Under this option, you will first create local images and push them to the Azure Container Registry, from where the application can be deployed to the AKS cluster. We will use azure-vote-all-in-one-redis.yaml file to deploy the application once we have the images ready.


## Steps
1. Run the application locally
```
# Navigate to the downloaded directory
cd azure-voting-app-redis
# Use docker-compose.yaml file to create images, and run the application locally using Docker.
# The command below will create two images - one for the frontend and another for backend. 
# The frontend image is built based on the Dockerfile present in the "/azure-vote/" directory. 
# The backend image is built based on a standard Redis image fetched from the Dockerhub
# If you wish, YOU CAN CHANGE THE IMAGE NAME:TAG  in the docker-compose.yaml file
docker-compose up -d
# View images locally 
# You will see two new images - "mcr.microsoft.com/azuredocs/azure-vote-front:v1" and "mcr.microsoft.com/oss/bitnami/redis:6.0.8"
docker images
# You will see two running containers - "azure-vote-front" and "azure-vote-back" 
docker ps
# Go to http://localhost:8080 see the app running
# Stop the application
docker-compose down
```


2. Create a Container Registry in Azure
This is where we can store the image, and AKS can later pull them during deployment to the AKS cluster.
```
# Create a resource group
# Cloud Lab users can ignore this command and should use the existing Resource group, such as "cloud-demo-XXXXXX" 
az group create --name myResourceGroup --location eastus
# ACR name should not have upper case letter
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
```

3. Create a Kubernetes cluster - You can create the cluster in one go using the create-cluster.sh shell script
```
# To ensure your cluster operates reliably, it is preferable to run at least 2 (two) nodes.
# For this exercise, let's start with just one node.
# NOTE: Cloud Lab users cannot use the "--enable-addons monitoring" option in the "az aks create" because they are not allowed to create the Log Analytics workspace.
# Instead, Cloud Lab users should enable the monitoring in a separate command "az aks enable-addons -a monitoring", as shown in the "create-cluster.sh" above, to use the existing Log Analytics workspace's Resource ID.
az aks create --name myAKSCluster \
 --resource-group myResourceGroup \
 --node-count 1 \
 --enable-addons monitoring \
 --generate-ssh-keys \
 --attach-acr myacr202106 
# To connect to the Kubernetes cluster from your local computer, you use kubectl, the Kubernetes command-line client.
# Preferable run as super user sudo
az aks install-cli
# Configure kubectl to connect to your Kubernetes cluster
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
# Verify the connection to your cluster
kubectl get nodes
```

4. Deploy the images to the AKS cluster
```
# Get the ACR login server name
az acr show --name myacr202106 --query loginServer --output table
```
Important step:
```
#  Edit the manifest file, *azure-vote-all-in-one-redis.yaml*, to replace `mcr.microsoft.com/azuredocs/azure-vote-front:v1` with `myacr202106.azurecr.io/azure-vote-front:v1`.  
# If you do not change the manifest file, then it will use Microsoft's image for this application available at Dockerhub - https://hub.docker.com/r/microsoft/azure-vote-front
# The reason for editing is that in order to push an image to ACR, the image needs to be tagged with the login server address of your registry. 
```
```
# Deploy the application. Run the command below from the parent directory where the *azure-vote-all-in-one-redis.yaml* file is present. 
kubectl apply -f azure-vote-all-in-one-redis.yaml
# Test the application
kubectl get service azure-vote-front --watch
# You can also verify that the service is running like this
kubectl get service
```


5. Troubleshoot
```
kubectl get pods
# It may require you to associate the AKS with the ACR
az aks update -n udacity-cluster -g acdnd-c4-project --attach-acr myacr202106
# Redeploy
kubectl set image deployment azure-vote-front azure-vote-front=myacr202106.azurecr.io/azure-vote-front:v1
```


6. Application Insights in AKS:

Once the application is deployed to the AKS, navigate to the AKS dashboard on the web portal. Click ‘Insights’ under the Monitoring section on your left, and enable the Application Insights . Refresh the dashboard. You will see data begin to populate the graphs. It could take up to 15 minutes.

We will be presented with various metrics and charts which show a comprehensive picture of our cluster. Once you enable Application Insight for an AKS cluster, you can easily answer the questions like:

“how many pods do we have?”,
“which pods are taking the most resources?”, and
“when was the last time our nodes increased in number?


7. Generate synthetic load, and autoscale the Pods

Let's first autoscale the number of pods in the azure-vote-front deployment. The following command will set the policy such that if average CPU utilization across all pods exceeds 50% of their requested usage, the autoscaler will increase the pods from a minimum of 3 instances up to a maximum of 10 instances.

```
kubectl autoscale deployment azure-vote-front --cpu-percent=50 --min=3 --max=10
```
Also, note that the deployment file azure-vote-all-in-one-redis.yaml used in the kubectl apply command already has the CPU requests and limits defined for all containers in your pods. The deployment file defines the azure-vote-front container to have 25% CPU requests, with a limit of 50% CPU.

```
     resources:
       requests:
         cpu: 250m
       limits:
         cpu: 500m
Reference: Autoscale pods
```

Now, to generate the synthetic load on the AKS cluster, you can run:

```
# Generate load in the terminal by creating a container with "busybox" image
# Open the bash into the container
kubectl run -it --rm load-generator --image=busybox /bin/sh
```
You will see a new command prompt. Enter the following in the new command prompt. It will send an infinite loop of queries to the cluster and increase the load on the cluster.

```
while true; do wget -q -O- [Public-IP]; done
```
Wait for a few minutes, and go back to the Azure AKS web portal, and check the Application Insights. Alternatively, you can run the following in a new terminal window:

```
# You can check the increase in the number of pods by using the command below
kubectl get hpa
```
Later, if you want to terminate the load generation, use <Ctrl> + C. Reference: Increase load on Kubernetes cluster


Do not delete the AKS cluster and related resources at this point. Although, you can delete the autoscaling at this moment.
```
# You can get name of HPA
kubectl get hpa
# Delete the horizontalpodautoscaler.autoscaling
kubectl delete hpa azure-vote-front 
```
