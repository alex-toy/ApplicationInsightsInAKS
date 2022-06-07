"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

$current_path = $pwd
Set-Location "C:\source\azure-voting-app-redis"
kubectl apply -f azure-vote-all-in-one-redis.yaml
Set-Location $current_path

# Test the application
kubectl get service azure-vote-front --watch

# You can also verify that the service is running like this
kubectl get service