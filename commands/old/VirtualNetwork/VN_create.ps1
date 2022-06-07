az network vnet subnet list `
  -g $RGName `
  --vnet-name linux-vm-westVNET


az network vnet subnet show `
    -g $RGName `
    -n linux-vm-westVNET `
    --vnet-name linux-vm-westSubnet