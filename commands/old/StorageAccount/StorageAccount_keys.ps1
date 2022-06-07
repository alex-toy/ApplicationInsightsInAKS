#######################################################################
# Get new keys from storage account :

$file = '.\commands\StorageAccount\keys.json'

az storage account keys renew `
   -g $RGName `
   -n $SAName `
   --key primary | Out-File $file

$json = Get-Content $file -Raw | ConvertFrom-Json 

$BLOB_STORAGE_KEY = $json[0].value
"BLOB STORAGE KEY : "  + $BLOB_STORAGE_KEY



#######################################################################
# Set config file :

$cfg_file = ".\commands\Configs\var.cfg"

(Get-Content -Path $cfg_file) | ForEach-Object { 
    $old = If ($_.split("=")[1]) {'BLOB_STORAGE_KEY=' + $_.split("=")[1]} Else {'BLOB_STORAGE_KEY'}
    $new = 'BLOB_STORAGE_KEY=' + $BLOB_STORAGE_KEY
    $_ -Replace $old, $new 
} | Set-Content -Path $cfg_file


#######################################################################
# Next step :

"Now run : commands\VirtualMachine\VM_create.ps1"

