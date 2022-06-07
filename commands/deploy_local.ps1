# Use docker-compose.yaml file to create images, and run the application locally using Docker.
# The command below will create two images - one for the frontend and another for backend. 
# The frontend image is built based on the Dockerfile present in the "/azure-vote/" directory. 
# The backend image is built based on a standard Redis image fetched from the Dockerhub
# If you wish, YOU CAN CHANGE THE IMAGE NAME:TAG  in the docker-compose.yaml file
docker-compose up -d
# View images locally 
# You will see two new images - "mcr.microsoft.com/azuredocs/azure-vote-front:v1" and "mcr.microsoft.com/oss/bitnami/redis:6.0.8"
docker images
# You will see two running containers - "azure-vote-front" and "azure-vote-back" 
docker ps
# Go to http://localhost:8080 see the app running
# Stop the application
docker-compose down