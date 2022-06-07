################################################################
#DELETE A VM :

az vm delete `
   --resource-group $RGName `
   --name $VMName `
    --yes