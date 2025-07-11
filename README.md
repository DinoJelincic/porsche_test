# porsche_test
The objective was to containerize and deploy Python application using Docker. Application is inside folder app in which Dockerfile was set. This Dockerffile defines all necessary steps to build Docker image. Building and pushing image to ECR is achived using Github Actions workflow.

Entire infrastructure is defined and provided via Terraform. That way reusability and version control is achived,. 
Infrastucture itself consist of next parts:
- VPC 
- Public and private subnets
- NAT and Internet Gateway
- Route tables
- Security groups
- S3 bucket
- VPC Endpoint
- IAM roles and policies
- Bastion instance
- EC2 instance
- Application Load Balancer
- Elastic Container Regfistry

Virtual private cloud is provided to achive network isolation and to provide custom IP address range. 
Inside provided VPC several subnets are also created so that resources inside created network could have needed network configuration (some resources need Internet access, some don't).

Internet Gateway allows resources in public subnets Internet access, and NAT Gateway provides outbound Internet access for resources inside private subnets.
Security Groups are used to set network rules (allowed ports and IP ranges).
S3 Bucket is used to store example.jpg image which is used by application.
Access to S3 Bucket is defined with IAM Roles and Policies which are give to EC2 instance. EC2 instance itself uses VPC Endpoint to access S3 Bucket. That way higer level of security is achieved because it doesn't use public Internet for communication. In terms of high security level EC2 instance is placed in private subnet. 
Bastion host is, for that question, created and placed in one of public subnets so that access to private ECC2 instance is possible. 
Right now access to Bastion host is allowed to anyone, for testing purposes, later it will be stricked to only IP address that belong to Github runners.

Application load balancer is used to publish application on https://porsche.odinops.solutions

Github Actions are used for CI/CD automation. OIDC (OpenID Connect) is used to authenticate GitHub and AWS for secure and temporary credentials.
Workflow is configured to:
- Python linter to check the code quailty
- build and push Docker image to ECR
- deploy application on EC2 instance
- provide entire infrastructure using Terraform

All sensitive data is stored in GitHub Secrets

P.S please wait 30 secound for application to load in, thank you! :)