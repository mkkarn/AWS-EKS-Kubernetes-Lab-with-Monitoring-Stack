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
