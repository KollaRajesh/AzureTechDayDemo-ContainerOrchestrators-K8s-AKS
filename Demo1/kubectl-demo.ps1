##https://minikube.sigs.k8s.io/docs/start/
##https://kubernetes.io/docs/tasks/tools/install-kubectl/

$env:Path=$env:path +";C:\Program Files\Kubernetes\Minikube"
minikube version 

minikube start –vm-driver=hyperkit

minikube status 

kubectl get pods
kubectl get services 
kubectl  create -h


Pod is the smallest unit  but you are creating  deployment  which is abstraction over pods
kubectl create  deployment Name –Image=Image  [--dry-run] [options]
kubectl create deployment nginx-deploy  --image=nginx
kubectl get pod 
kubectl  get deployment 
kubectl get replicaset

kubectl edit deployment

kubectl edit deployment nginxapp
kubectl create deployment mongo-depl --image=mongo

kubectl create deployment mongo-depl --image=mongo
kubectl get deployment
kubectl get replicaset
kubectl get pod
kubectl describe pod  <podname>
kubectl logs <podname>


##Debugging Pods
kubectl exec -it  <podid>   -- bin /bash

kubectl create deployment mongo-depl

kubectl apply -f  deployment-config.yaml

