# Azure-AKS
This repository contains demo Terraform code to provision an AKS (Azure Kubernetes Service) cluster.

Before using this code, you need to create a new free trial account in the Azure cloud and complete a few prerequisites like setting up a prerequisite VNET, Subnet, etc.

Note: There are many restrictions with a free account, such as a maximum 4 CPU quota is allowed. To increase the quota, you have to convert your account. For the provision of an AKS cluster, nodes should have a minimum of 2 CPUs, etc. All details have been added in the attached Word document. Also, due to the CPU limit, you have to create the AKS cluster as public because to access a private cluster, we need bastion, etc. In production environments, mostly clusters will be in private.

Please find below the structure details:

.
├── README.md
├── company-abc
│   └── environments
│       ├── aws
│       │   └── prod
│       │       ├── main.tf
│       │       └── variables.tf
│       ├── azure
│       │   └── stage
│       │       ├── backend.tf
│       │       ├── main.tf
│       │       ├── providers.tf
│       │       ├── terraform.tfvars
│       │       └── variables.tf
│       └── gcp
│           └── UAT
│               ├── main.tf
│               └── variables.tf
├── company-efg
│   └── environments
│       ├── aws
│       │   └── prod
│       │       ├── main.tf
│       │       └── variables.tf
│       ├── azure
│       │   └── stage
│       │       ├── main.tf
│       │       └── variables.tf
│       └── gcp
│           └── UAT
│               ├── main.tf
│               └── variables.tf
├── helm-chart
│   ├── nginx
│   │   └── values.yaml
│   └── prom-kube-prometheus-stack
│       └── values.yaml
└── modules
    ├── aws
    │   ├── ec2
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── eks
    │       ├── main.tf
    │       └── variables.tf
    ├── azure
    │   ├── aks
    │   │   ├── bootstrap.tf
    │   │   ├── data.tf
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   └── variables.tf
    │   └── vm
    │       ├── main.tf
    │       └── variables.tf
    └── gcp
        ├── gke
        │   ├── main.tf
        │   └── variables.tf
        └── vm
            ├── main.tf
            └── variables.tf
            
### AKS Cluster and Nginx/Prometheus Stack Deployment

how to provision an AKS cluster using a Terraform module and install Nginx and Prometheus stacks using Helm charts with custom values. After the cluster is up and running, Nginx and Grafana will be exposed to the internet using an ingress object.

### AKS Cluster Creation

Go to the respective directory of the Terraform module, e.g. company-abc/azure/stage, and make changes to the variables as per your requirements.

Run the following commands:
``` 
terraform init
terraform plan
terraform apply -auto-approve (optional)
```
#### Installing Nginx and Prometheus Stack using Helm

 Add the required Helm repositories:
``` 
 helm repo add my-repo https://charts.bitnami.com/bitnami
 helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
``` 
helm repo list

``` 
NAME                	URL                                               
my-repo             	https://charts.bitnami.com/bitnami                
prometheus-community	https://prometheus-community.github.io/helm-charts
``` 
Navigate to the helm-charts directory and the respective directory to use their values.yaml.

### Run the following command to install Nginx:

helm install my-release my-repo/nginx -f values.yaml -n services
``` 
NAME: my-release
LAST DEPLOYED: Sat Mar  4 02:04:53 2023
NAMESPACE: services
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 13.2.28
APP VERSION: 1.23.3
``` 

helm install prom prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml

### Run the following command to install Prometheus:
``` 
NAME: prom
LAST DEPLOYED: Sat Mar  4 02:09:47 2023
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
``` 
* Note: Update the ipadress in DNS

kubectl get ing -A
``` 
NAMESPACE    NAME               CLASS    HOSTS                      ADDRESS          PORTS     AGE
monitoring   prom-grafana       <none>   grafana.devopsnilesh.xyz   20.204.XX.XX   80, 443   118s
services     my-release-nginx   <none>   devopsnilesh.xyz           20.204.XX.XX   80, 443   7m10s

``` 

