################################################################################
# Dev Environment - Main Configuration
################################################################################

locals {
  cluster_name = "${var.project_name}-${var.environment}"
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/vpc?ref=main"

  cluster_name       = local.cluster_name
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  single_nat_gateway = true # Cost optimization
  tags               = local.tags
}

module "eks" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/eks?ref=main"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  node_groups = var.node_groups
  tags        = local.tags
}

module "ingress_controller" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/ingress-controller?ref=main"

  namespace     = "ingress-nginx"
  replica_count = 1

  depends_on = [module.eks]
}

module "prometheus_grafana" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/prometheus-grafana?ref=main"

  namespace               = "monitoring"
  environment             = var.environment
  storage_class_name      = "gp3"
  grafana_admin_password  = var.grafana_admin_password
  prometheus_retention    = "7d"
  prometheus_storage_size = var.prometheus_storage_size
  grafana_storage_size    = var.grafana_storage_size

  depends_on = [module.eks]
}

module "elk_stack" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/elk-stack?ref=main"

  namespace                  = "logging"
  environment                = var.environment
  elasticsearch_replicas     = 1
  elasticsearch_storage_size = var.elasticsearch_storage_size
  storage_class_name         = "gp3"

  depends_on = [module.eks]
}

module "argo_cd" {
  source = "git::https://github.com/mkkarn/AWS-EKS-Kubernetes-Lab-with-Monitoring-Stack.git//modules/argo-cd?ref=main"

  namespace = "argocd"

  depends_on = [module.eks]
}

