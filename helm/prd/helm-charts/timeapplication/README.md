# Install application via helm chart 
Here's described how to manually install the application helm chart in an EKS cluster. 

```sh
cd helm/prd/helm-charts
helm install --create-namespace --namespace <your_namespace_name> <release_name> timeapplication
```
After the helm is deployed, here are some commands that can be helpful to check the if the pods are running as expected. Also to get the service endpoint
```sh
kubectl get pods --namespace <your_namespace_name>
kubectl describe pod <pod_name> --namespace <your_namespace_name>
kubectl get svc --namespace <your_namespace_name>
```
In the svc command you can check the public endpoint and then access it. 
