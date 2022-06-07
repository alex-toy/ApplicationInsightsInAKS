################################################################
# Find the outbound IP addresses currently used by your app :

az webapp show `
    --resource-group $RGName `
    --name $WAName `
    --query outboundIpAddresses `
    --output tsv


################################################################
# Find all possible outbound IP addresses for your app, regardless of pricing tiers :

az webapp show `
    --resource-group $RGName `
    --name $WAName `
    --query possibleOutboundIpAddresses `
    --output tsv


################################################################
# Find all possible outbound IP addresses for your app, regardless of pricing tiers :

cd folder-containing-web-app

az webapp up --location <myLocation> --name <myAppName> --html


################################################################
# Stream logs live :

az webapp log tail --name appname --resource-group myResourceGroup

# For logs stored in the App Service file system, the easiest way is to download the ZIP file in the browser at:
# Linux/container apps: 
https://<app-name>.scm.azurewebsites.net/api/logs/docker/zip

#Windows apps: 
https://<app-name>.scm.azurewebsites.net/api/dump

# For Linux/container apps, the ZIP file contains console output logs for both the docker host and the docker container. 
# For a scaled-out app, the ZIP file contains one set of logs for each instance. 
# In the App Service file system, these log files are the contents of the /home/LogFiles directory.





# az webapp up --location <myLocation> --name <myAppName> --html

#update your app, make changes to your code, and then run (Note: this may not update new requirements you may have added):
# az webapp up `
#     --name $WebAppName `
#     --verbose

az webapp list-runtimes --os "linux"
az webapp list-runtimes --os-type windows