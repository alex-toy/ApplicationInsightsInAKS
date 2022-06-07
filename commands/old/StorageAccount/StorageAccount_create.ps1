"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"



################################################################
"Storage Account configuration :"

$Global:SAName = "flaskstorageaccount"
"Storage Account name : " + $SAName

#southcentralus centralus francecentral
$Global:SALocation = $RGLocation
"Storage Account Location : " + $SALocation

$Global:SAKind = "BlockBlobStorage"
"Storage Account kind : " + $SAKind

$Global:SASKU = "Standard_LRS"
"Storage Account SKU : " + $SASKU

$Global:SCName = "flask-images"
"Storage container name : " + $SCName

$Global:SCAuthMode = "login"
"Storage container auth mode : " + $SCAuthMode

$Global:SCPublicAccess = "container"
"Storage container public access : " + $SCPublicAccess



#######################################################################
"Set config file :"

$file = ".\commands\Configs\var.cfg"
(Get-Content -Path $file) | ForEach-Object { 
    if($_.split("=")[0] -like 'BLOB*') {
        $new = $_.split("=")[0]; $new
    } else {
        $_
    }
} | Set-Content -Path $file

(Get-Content -Path $file) | ForEach-Object { $rep = 'BLOB_ACCOUNT=' + $SAName; $_ -Replace 'BLOB_ACCOUNT', $rep } | Set-Content -Path $file
(Get-Content -Path $file) | ForEach-Object { $rep = 'BLOB_CONTAINER=' + $SCName; $_ -Replace 'BLOB_CONTAINER', $rep } | Set-Content -Path $file
(Get-Content -Path $file) | ForEach-Object { $rep = 'BLOB_STORAGE_KEY=' + $BLOB_STORAGE_KEY; $_ -Replace 'BLOB_STORAGE_KEY', $rep } | Set-Content -Path $file



################################################################
"Create the block blob storage account :"

az storage account create `
    --resource-group $RGName `
    --name $SAName `
    --location $SALocation `
    --sku $SASKU
    #--kind $SAKind `


################################################################
"Create the container :"

az storage container create `
 --account-name $SAName `
 --name $SCName `
 --auth-mode $SCAuthMode `
 --public-access $SCPublicAccess


#######################################################################
"Create the queue :"

az storage queue create `
    --name alexeistoragequeue `
    --account-name $SAName 
    # [--account-key]
    # [--auth-mode {key, login}]
    # [--connection-string]
    # [--fail-on-exist]
    # [--metadata]
    # [--queue-endpoint]
    # [--sas-token]
    # [--timeout]


