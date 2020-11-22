kubectl apply -f .\1.mongo-Secret.yml
kebectl get secret
kubectl apply -f .\2.mongo-configmap.yml
kubectl get pod
kubectl get pod --watch
kubectl get replicaset
kubectl get deployment

kubectl apply -f .\3.mongo-deployment-config.yml
kubectl get services 
kubectl describe service  mongodb-service
kubectl get pod -o wide
kubectl get pod --watch
kubectl get replicaset
kubectl get deployment


kubectl apply -f .\2.mongo-configmap.yml
kubectl get configmap


kubectl apply -f .\4.mongo-express-deployment-config.yml
kubectl get services 
kubectl describe service  mongodb-service
kubectl get pod -o wide

kubectl logs mongo-expressmyapp-54fc968548-gw2gj


kubectl apply -f .\4.mongo-express-deployment-config.yml
kubectl get services  --watch
