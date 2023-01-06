# Simple time application
This repository contains a simple python based application deployed in an EKS cluster that exposes two endpoints:
- http://host:8080/ - returns local time in New-York, Berlin, Tokyo in HTML format
- http://host:8080/health - return status code 200, in JSON format

## Repository structure
This repository is divided in the following way:
- The folder **app** that contains the python code to the app, the requirements and the Dockerfile;
- The folder **helm** that contains the helm chart with the templates and values to deploy the python application to EKS;
- The folder **terraform** that contains the terraform code to provision the VPC and all the other network components. Also contains the code to provision the EKS, ECR, S3 and dynamoDB (both used to manage terraform remote state);
- The folder **terraform_modules** that contains the module that was used to create the ECR;

In the following section is detailed what's deployed and what's being used. 

## Implementation
### App folder
In this folder is the python application and the Dockerfile used to build it.
- The **app.py** is the python code that implements the two routes endpoints previously described. This endpoints are implemented using a framework called `Flask` that simplifies some additional code;
- The **requirements.txt** defines the dependencies that are necessary for the application to run;
- In the **Dockerfile** are the instructions so that this app can be built and run as a container;

### Helm folder 
In this folder is where all the helm dependencies are created to deploy the python application to the EKS cluster. 

In the `templates` folder is where are defined the kubernetes manifests already templated:
- `deployment.yaml`: it's where are defined the deployment configurations that we will be used. It's where is defined the container name and image, where it's defined the port that will be exposed, the resources that we want the pods to use, the readiness and liveness, etc;
- `service.yaml`: definition of the service to expose the application and therefore to make it available to the outside world. In this specific service a load balancer (NLB) will be created in AWS exposing port 8080 so the python application can be accessed from the internet.

In the root of this folder there are two files: `Chart.yaml` and `values.yaml`:
- `Chart.yaml`: defining the name of the chart and the version;
- `values.yaml`: defining the configurations for the chart. In this case defining replicas, image, tag and resources;

### Terraform folder
In this folder resides all the terraform code that is necessary to create the infrastructure in AWS: VPC, subnets, security groups, route tables, EKS and ECR.
#### `terraform/prd/aws/eu-west-1/base/general`
In the path `terraform/prd/aws/eu-west-1/base/general` is where all the network resources are deployed by making use of the AWS VPC module available [online](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest). There are a lot of available options in this module, in this specific case what's being deployed:
   - A VPC with a CIDR block of `10.0.0.0/20`;
   - Three public subnets with a NAT gateway per subnet/availability zone. Meaning we have three NAT's with three Elastic IPs;
   - Three private subnets;
   - One internet gateway;
   - Three route tables created in each one of the availability zones. This are meant to be used by each one of the private subnets. These route tables have routes to the local VPC and, in order to go the internet, they have a route for the respective NAT gateway;
   - One route table for all the public subnets that have routes to the local VPC and in order to go the internet they have a route for the internet gateway;
#### `terraform/prd/aws/eu-west-1/ecr/general`
In the path `terraform/prd/aws/eu-west-1/ecr/general` is where the ECR resource is deployed by making use of a  [module](terraform_modules/ecr) that was created for the purpose. An ECR is created with the following parameters:
- A name is set for the ECR, that will be in the form of `repo/image`;
- Mutability is set to immutable to avoid pushes to the ECR with the same tatg. So if you attempt to push an image with a tag that is already in the repository an error will be returned;

#### `terraform/prd/aws/eu-west-1/eks/general`
In the path `terraform/prd/aws/eu-west-1/eks/general` is where all the EKS resources are deployed by making use of the AWS EKS module available [online](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest). There are a lot of available options in this module, in this specific case what's being deployed:
   - The EKS it's created on the VPC and the subnets that were previously deployed;
   - One node group is being deployed with an instance type of `t3.small` and a desired node count of `1` (with a min and max also being set). Using an AMI owned by AWS `AL2_X86_64` that is linux based;
   - EKS cluster being created with a public endpoint - this means it will be accepting requests incoming from all the internet (0.0.0.0/0);
   - Multiple IAM roles/policies being deployed on the background:
        - Allow EKS nodes and cluster to assume role `sts:AssumeRole`;
        - Allow `AmazonEC2ContainerRegistryReadOnly` to allow pull from ECR in EKS, `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`;
   - Multiple security groups being deployed on the background:
        - EKS cluster security group that allows 443 requests from the nodegroups to the EKS API;
        - EKS node shared security group with multiple rules: Accepting traffic from the internet (0.0.0.0/0), accept requests from the EKS API to the nodegroups, accept requests from the cluster API to node groups 443, accept requests from the cluster API to node 4443/tcp webhook, accept requests from the cluster API to the 8443/tcp webhook, accept requests from the cluster API to the 9443/tcp webhook, accept requests from the cluster API to the 10250/tcp node kubelets, accept requests from the cluster API to the 1025/tcp node ingress on ephemeral ports, accept requests from the cluster API to the 53/tcp node CoreDNS, accept requests from the cluster API to the 53/tcp node CoreDNS UDP;
    - Create custom KMS key to enable encryption. Also includes permissions so EKS can use this KMS key.
#### `terraform/prd/aws/eu-west-1/s3/remotestate`
In the path `terraform/prd/aws/eu-west-1/s3/remotestate` is where all the the S3, that will be used for remote state management, is deployed by making use of the AWS S3 module available [online](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest). There are some options in this module, in this specific case what's being deployed:
- Give the bucket a name and set the acl to private;
- It's also being created a DynamoDB to store the state lock. It's creating an hash key with the name "LockID". 

## References
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
- https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
 
