"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Batch configuration :"

$Global:BAName = "alexeiba"
"Batch Account name : "  + $BAName

$Global:BAApplicationName = "alexeibaa"
"Batch Application name : "  + $BAApplicationName

$Global:BAPoolId = "alexeipoolid"
"Pool Id : "  + $BAPoolId

$Global:BAJobId = "alexeijobid1"
"Job Id : "  + $BAJobId



################################################################
"CREATE A BATCH ACCOUNT :"

az batch account create `
    --resource-group $RGName `
    --name $BAName `
    --location $RGLocation `
    --storage-account $SAName
    # [--encryption-key-identifier]
    # [--encryption-key-source {Microsoft.Batch, Microsoft.KeyVault}]
    # [--identity-type {None, SystemAssigned, UserAssigned}]
    # [--keyvault]
    # [--no-wait]
    # [--public-network-access {Disabled, Enabled}]
    # [--tags]


################################################################
"CREATE A BATCH APPLICATION:"

az batch application create `
    --resource-group $RGName `
    --name $BAName `
    --application-name $BAApplicationName
    # [--parameters]

az batch application package create `
    --resource-group $RGName `
    --application-name $BAName `
    --name $BAName `
    --package-file "stockrecommender.zip" `
    --version-name 1.0.0

################################################################
"CREATE A BATCH POOL:"

az batch pool create `
    --id $BAPoolId `
    --vm-size "Standard_B1s" `
    --target-dedicated-nodes 1
    # [--account-endpoint]
    # [--account-key]
    # [--account-name]
    # [--application-licenses]
    # [--application-package-references]
    # [--auto-scale-formula]
    # [--certificate-references]
    # [--disk-encryption-targets]
    # [--enable-inter-node-communication]
    # [--image]
    # [--json-file]
    # [--metadata]
    # [--node-agent-sku-id]
    # [--os-family {2, 3, 4, 5, 6}]
    # [--os-version]
    # [--policy {regional, zonal}]
    # [--resize-timeout]
    # [--start-task-command-line]
    # [--start-task-resource-files]
    # [--start-task-wait-for-success]
    # [--target-dedicated-nodes]
    # [--target-low-priority-nodes]
    # [--targets]
    # [--task-slots-per-node]



################################################################
"CREATE A BATCH JOB:"

az batch job create `
    --id alexeijob1 `
    --pool-id $BAPoolId
    # [--account-endpoint]
    # [--account-key]
    # [--account-name]
    # [--allow-task-preemption]
    # [--job-manager-task-command-line]
    # [--job-manager-task-environment-settings]
    # [--job-manager-task-id]
    # [--job-manager-task-resource-files]
    # [--job-max-task-retry-count]
    # [--job-max-wall-clock-time]
    # [--json-file]
    # [--max-parallel-tasks]
    # [--metadata]
    # [--priority]
    # [--required-slots]
    # [--uses-task-dependencies]


    
################################################################
"CREATE A BATCH TASK:"

az batch task create `
    --job-id $BAJobId `
    --task-id alexeitaskid1 `
    --command-line "stockrecommender.zip"
    # [--account-endpoint]
    # [--account-key]
    # [--account-name]
    # [--affinity-id]
    # [--application-package-references]
    # [--environment-settings]
    # [--json-file]
    # [--max-task-retry-count]
    # [--max-wall-clock-time]
    # [--resource-files]
    # [--retention-time]

    