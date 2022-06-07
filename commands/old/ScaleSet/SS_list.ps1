#List the address and ports to connect to VM instances in a scale set :
az vmss list-instance-connection-info `
  --resource-group $RGName `
  --name udacity-vmss

az vm list-skus --location francecentral --size Standard_B --all --output table
az vm list-skus --location francecentral --size Standard_B --output table