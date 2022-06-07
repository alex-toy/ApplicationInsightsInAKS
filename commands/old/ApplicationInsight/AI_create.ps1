"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"


################################################################
# To access the preview Application Insights Azure CLI commands, you first need to run:
# az extension add -n application-insights


################################################################
"Application insight configuration :"

$Global:AIName = "alexeiai"
"Application insight name : "  + $BAName

$Global:BAApplicationName = "alexeibaa"
"Batch Application name : "  + $BAApplicationName



################################################################
"CREATE AN APPLICATION INSIGHT :"

az monitor app-insights component create `
    --resource-group $RGName `
    --app $AIName `
    --location $RGLocation `
    # [--application-type]
    # [--kind]
    # [--tags]






