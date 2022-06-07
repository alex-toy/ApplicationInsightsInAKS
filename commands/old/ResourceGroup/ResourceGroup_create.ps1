"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

################################################################
"CREATE A RESOURCE GROUP :"

az group create --name $RGName --location $RGLocation


#######################################################################
# Next step :

# $script = "commands\StorageAccount\StorageAccount_create.ps1"
# .$script

# $script = "commands\ContainerRegistry\ACR_create.ps1"
# .$script



