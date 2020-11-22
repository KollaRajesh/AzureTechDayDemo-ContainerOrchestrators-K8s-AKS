kubectl apply -f .\Demo2\nginxDeployment-config.yaml
kubectl apply -f .\Demo2\nginxService-config.yml
kubectl get service 
kubectl get deployment
kubectl get replicaset
kubectl get pod  wide
kubectl describe service nginx-service
kubectl get pod -o wide
kubectl  get deployment -o yaml  > .\Demo2\nginxDeployment-configExtract.yaml

certutil -encode  .\demo3\input-file.txt encoded-output.txt
