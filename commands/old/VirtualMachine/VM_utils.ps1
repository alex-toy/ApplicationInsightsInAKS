################################################################
#IP addresses :
$Global:IP = az vm list-ip-addresses -g $RGName -n $VMName | Out-String
"IP : " + $IP


################################################################
#Reset password
az vm user update `
  -n $VMName `
  -g $RGName `
  -u $AdminUsername `
  -p ""


################################################################
#SSH key
$SSHKeyName = "mySSHKey"

az sshkey create `
  --name $SSHKeyName `
  --resource-group $RGName

az sshkey list `
  --resource-group $RGName

az sshkey show `
  --name $SSHKeyName `
  --resource-group $RGName