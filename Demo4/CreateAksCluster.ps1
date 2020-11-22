
##1. clone  voting app from git 

git clone https://github.com/Azure-Samples/azure-voting-app-redis.git

Set-Location .\azure-voting-app-redis\

##2.  deploy voting app using  docker-compose

docker-compose up -d
docker images
docker-compose down


$acrresourceGroup = "aztechdaysacr"

$location = "eastus"

$acr = "aztechdaysacr"

## 3. create resource group

az group create --name  $acrresourceGroup  --location $location 

## 4. create azure container registry 

az acr create --resource-group $acrresourceGroup --name $acr --sku Basic

## 5.login azure container registry 

az acr login --name $acr

docker images

## 6. get acr login server

##az acr list --resource-group $acrresourceGroup --query "[].{acrLoginServer:loginServer}" --output table

$loginServer = az acr list --resource-group $acrresourceGroup  --query "[0].loginServer"

## 7. create tag using login server
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 $loginServer /azure-vote-front:v1

## 8. push voting image to acr 
docker push $loginServer/azure-vote-front:v1

## 9. get repository from acr
##az acr repository list --name $acr --output table
$azurevotefront=az acr repository list --name $acr --query "[0]"

## 10. get tags from acr 
az acr repository show-tags --name $acr --repository $azurevotefront --output table


###########################################################################################################################
#Create aks cluster
#############################################################################################################################
$aksCluster="aztechdAksClstr"
$resourceGroup = "aztechdaysaks"
$location ="eastus"
az group create --name  $resourceGroup  --location $location 
az aks create `
    --resource-group $resourceGroup `
    --name $aksCluster `
    --node-count 2 `
    --generate-ssh-keys `
    --attach-acr  $acr

##install cli
az aks install-cli


##get-credentials for aks cluster
az aks get-credentials --resource-group $resourceGroup --name $aksCluster

##get nodes
kubectl get nodes


#########################################################################################################################################
#Deploy application 
########################################################################################################################################
$loginServer = az acr list --resource-group $acrresourceGroup  --query "[0].loginServer"

notepad  azure-vote-all-in-one-redis.yaml

#########################################################################################################
## Update registername for container in yaml file  
#########################################################################################################
##containers:
##- name: azure-vote-front
##  image: <$acr>.azurecr.io/azure-vote-front:v1

kubectl apply -f azure-vote-all-in-one-redis.yaml

#############################################################################################################################
#Scale application in Aks 

kubectl scale --replicas=5 deployment/azure-vote-front

####get aks cluster version 
az aks show --resource-group $resourceGroup --name $aksCluster --query kubernetesVersion --output table

#############################################################################################################################
#enable auto scaling pods  in Aks 

kubectl autoscale deployment azure-vote-front --cpu-percent=50 --min=3 --max=10

####################################################################################
# apply  horizontal pod autoscaler

kubectl apply -f .\azure-vote-hpa.yml

####################################################################################
# get horizontal pod autoscaler

kubectl get hpa

####################################################################################
#Manually scale AKS nodes

az aks scale --resource-group $resourceGroup --name $aksCluster --node-count 3


########################################################################################################
# Update application  - update config values in azure-vote/azure-vote/config_file.cfg
########################################################################################################

#######################################################
# Update container images 
docker-compose up --build -d

 
$loginServer = az acr list --resource-group $acrresourceGroup  --query "[0].loginServer"

## add tag
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 $loginServer/azure-vote-front:v2

docker push $loginServer/azure-vote-front:v2

### scale front pods if dont have much pods 
kubectl scale --replicas=3 deployment/azure-vote-front


###update lastet container image  (or) update yaml file and apply yaml file

kubectl set image deployment azure-vote-front azure-vote-front= $loginServer/azure-vote-front:v2


### Get upgrades 
az aks get-upgrades --resource-group $resourceGroup --name $aksCluster

## upgrade cluster 
$KUBERNETES_VERSION="1.18.8"
az aks upgrade `
    --resource-group $resourceGroup `
    --name $aksCluster `
    --kubernetes-version $KUBERNETES_VERSION


az aks show --resource-group $resourceGroup --name $aksCluster --output table

az group delete --name $resourceGroup --yes --no-wait

az group show --name $resourceGroup