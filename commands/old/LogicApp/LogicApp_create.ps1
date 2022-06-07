"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
"CREATE A LOGIC APP :"

az logic workflow create 
    --definition
    --location
    --name
    --resource-group
    [--access-control]
    [--endpoints-configuration]
    [--integration-account]
    [--integration-service-environment]
    [--state {Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended}]
    [--tags]