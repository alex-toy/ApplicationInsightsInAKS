"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Container Registry configuration :"

$Global:CRName = "alexeicr"
"Container registry name  : "  + $CRName

$Global:CRSKU = "Basic"
"SKU : "  + $CRSKU

$Global:DockerImageName = "alexeidockerimage"
"Docker Image Name : "  + $DockerImageName

$Global:DockerImageTag = "v1"
"Docker Image Tag : "  + $DockerImageTag


################################################################
"# Generate a Dockerfile :"

#cd to web directory
$init_path = $pwd
Set-Location ".\app"

func init --docker-only --python



################################################################
"CREATE A DOCKER IMAGE :"

# docker build -t <name:tag> <path>
docker build -t ${DockerImageName}:${DockerImageTag} .


################################################################
"Create a repository in ACR service :"

az acr create `
    --resource-group $RGName `
    --name $CRName `
    --sku $CRSKU


################################################################
"Push image to repository :"

# Tag the image with the same name as the ACR respository, else, the push will fail.
# docker tag <name:tag> <ACR-respository>.azurecr.io/<name:tag>
$container = ".azurecr.io/"
docker tag ${DockerImageName}:${DockerImageTag} ${CRName}${container}${DockerImageName}:${DockerImageTag}

az acr login --name $CRName

# Go to Container Registry >> Settings >> Access Keys and enable the Admin user. 
# Use those credentials to login from your terminal. 
# docker login ${CRName}.azurecr.io
docker push ${CRName}${container}${DockerImageName}:${DockerImageTag}

#Go back to root folder
Set-Location $init_path


#######################################################################
# Next step :

# $script = "commands\ContainerRegistry\KubernetesCluster_create.ps1"
# .$script






