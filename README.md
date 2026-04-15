# AWS EKS Kubernetes Lab

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-purple.svg)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS-orange.svg)](https://aws.amazon.com/eks/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A production-grade Terraform project for deploying a complete Kubernetes lab environment on AWS EKS with comprehensive monitoring and logging stack.

## 🚀 Features

- **AWS EKS Cluster** with managed node groups
- **VPC** with public/private subnets across multiple AZs
- **Prometheus & Grafana** for metrics and visualization
- **ELK Stack** (Elasticsearch, Logstash, Kibana, Filebeat) for logging
- **NGINX Ingress Controller** for traffic management
- **15 Practice Scenarios** for Kubernetes interview preparation

## 📋 Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5.0
- kubectl >= 1.28
- Helm >= 3.12
- AWS Account with sufficient permissions

## 🏗️ Architecture
┌─────────────────────────────────────────────────────────────────┐
│ AWS Cloud │
│ ┌───────────────────────────────────────────────────────────┐ │
│ │ VPC │ │
│ │ ┌─────────────────┐ ┌─────────────────┐ │ │
│ │ │ Public Subnet │ │ Public Subnet │ │ │
│ │ │ (AZ-1) │ │ (AZ-2) │ │ │
│ │ │ NAT Gateway │ │ NAT Gateway │ │ │
│ │ └────────┬────────┘ └────────┬────────┘ │ │
│ │ │ │ │ │
│ │ ┌────────┴────────┐ ┌────────┴────────┐ │ │
│ │ │ Private Subnet │ │ Private Subnet │ │ │
│ │ │ (AZ-1) │ │ (AZ-2) │ │ │
│ │ │ ┌───────────┐ │ │ ┌───────────┐ │ │ │
│ │ │ │EKS Worker │ │ │ │EKS Worker │ │ │ │
│ │ │ │ Nodes │ │ │ │ Nodes │ │ │ │
│ │ │ └───────────┘ │ │ └───────────┘ │ │ │
│ │ └─────────────────┘ └─────────────────┘ │ │
│ │ │ │
│ │ ┌─────────────────────────────────────────────────────┐ │ │
│ │ │ EKS Cluster │ │ │
│ │ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │ │ │
│ │ │ │ Prometheus │ │ Grafana │ │ NGINX │ │ │ │
│ │ │ │ │ │ │ │ Ingress │ │ │ │
│ │ │ └─────────────┘ └─────────────┘ └─────────────┘ │ │ │
│ │ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │ │ │
│ │ │ │Elasticsearch│ │ Logstash │ │ Kibana │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │
│ │ │ └─────────────┘ └─────────────┘ └─────────────┘ │ │ │
│ │ └─────────────────────────────────────────────────────┘ │ │
│ └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘

eks-kubernetes-lab/
├── README.md
├── .gitignore
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars
│       ├── backend.tf
│       └── providers.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── iam.tf
│   │   ├── node-groups.tf
│   │   └── versions.tf
│   ├── prometheus-grafana/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── values/
│   │       ├── prometheus-values.yaml
│   │       └── grafana-values.yaml
│   ├── elk-stack/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── values/
│   │       ├── elasticsearch-values.yaml
│   │       ├── logstash-values.yaml
│   │       ├── kibana-values.yaml
│   │       └── filebeat-values.yaml
│   ├── ingress-controller/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   └── argo-cd/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf


# AWS EKS Kubernetes Lab with Monitoring Stack

A professional Terraform project for a complete Kubernetes lab on AWS EKS in the Mumbai region (`ap-south-1`), optimized for cost-effectiveness using `m7i-flex.large` instances.

## 🚀 Features

- **AWS EKS Cluster** with managed node groups (`m7i-flex.large`).
- **VPC** with public/private subnets in `ap-south-1`.
- **Prometheus & Grafana** for metrics and visualization.
- **ELK Stack** for centralized logging.
- **NGINX Ingress Controller** for traffic management.
- **Argo CD** for GitOps continuous delivery.

## 📋 Prerequisites

- AWS CLI configured for the `ap-south-1` region.
- Terraform >= 1.5.0
- kubectl >= 1.28
- Helm >= 3.12

## 🛠️ Quick Start

### 1. Setup Terraform Backend (One-time)

You need an S3 bucket and DynamoDB table for state management. Run these AWS CLI commands:

```bash
# Replace with a unique bucket name
BUCKET_NAME="your-unique-terraform-state-bucket-ap-south-1"

# Create S3 Bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

# Enable Versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Create DynamoDB Table for State Locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1


=================================================================================================================================

Configure Your Environment

   1> Navigate to environments/dev/.
   2> Copy terraform.tfvars.example to terraform.tfvars.
   3> Edit terraform.tfvars:
       . Set your grafana_admin_password.
       . Update the bucket_name and dynamodb_table_name in backend.tf with the names you just created.

=================================================================================================================================

### Deply the cluster ###

cd environments/dev

# Initialize Terraform
terraform init

# Validate the configuration
terraform validate

# Plan the deployment
terraform plan

# Apply the changes
terraform apply --auto-approve

=================================================================================================================================

###### Configure kubectl ##########

After deployment, configure you kubectl to connect to the EKS cluster:

aws eks update-kubeconfig --region ap-south-1 --name $(terraform output -raw cluster_name)

================================================================================================================================

Access Dashboards

    Grafana: kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
    Kibana (ELK): kubectl port-forward -n logging svc/kibana-kibana 5601:5601
    Argo CD: kubectl port-forward -n argocd svc/argocd-server 8080:443

==============================================================================================================================

Destroy Infrastructure (Save Costs!)

When you are done practicing, destroy the infrastructure to avoid charges:

terraform destroy --auto-approve

Cost Estimation (Mumbai Region)

    Hourly Cost (when running): ~$0.30 - $0.35 USD
    Your Credit: $120 USD
    Potential Practice Time: 340+ hours!

