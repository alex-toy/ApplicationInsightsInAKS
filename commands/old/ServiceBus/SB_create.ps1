"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"Service Bus configuration :"

$Global:SBName = "alexeisb"
"Service Bus Name  : "  + $SBName

$Global:SBNamespaceName = "alexeinssb"
"Service Bus Namespace  : "  + $SBNamespaceName


################################################################
"CREATE A SERVICE BUS NAMESPACE :"

az servicebus namespace create `
    --resource-group $RGName `
    --name $SBNamespaceName `
    --sku Basic
    # [--capacity {1, 16, 2, 4, 8}]
    # [--default-action]
    # [--encryption-config]
    # [--location]
    # [--mi-system-assigned {false, true}]
    # [--mi-user-assigned]
    # [--tags]
    # [--zone-redundant {false, true}]


################################################################
"CREATE A SERVICE BUS QUEUE :"

az servicebus queue create `
    --resource-group $RGName `
    --name $SBName `
    --namespace-name $SBNamespaceName `
    --max-size 1024 `
    --enable-partitioning true
    # [--auto-delete-on-idle]
    # [--default-message-time-to-live]
    # [--duplicate-detection-history-time-window]
    # [--enable-batched-operations {false, true}]
    # [--enable-dead-lettering-on-message-expiration {false, true}]
    # [--enable-duplicate-detection {false, true}]
    # [--enable-express {false, true}]
    # [}]
    # [--enable-session {false, true}]
    # [--forward-dead-lettered-messages-to]
    # [--forward-to]
    # [--lock-duration]
    # [--max-delivery-count]
    # [--status {Active, Disabled, ReceiveDisabled, SendDisabled}]


################################################################
"GET THE CONNECTION STRINGS :"

$Global:ConnectionString = az servicebus namespace authorization-rule keys list `
    --resource-group $RGName `
    --namespace-name $SBNamespaceName `
    --name RootManageSharedAccessKey `
    --query primaryConnectionString 