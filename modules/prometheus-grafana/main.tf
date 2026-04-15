################################################################################
# Prometheus & Grafana Module
# Deploys monitoring stack using Helm
################################################################################

locals {
  namespace = var.namespace
}

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = local.namespace

    labels = {
      name        = local.namespace
      environment = var.environment
    }
  }
}

################################################################################
# Prometheus Stack (includes Grafana)
################################################################################

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_stack_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  timeout = 600

  values = [
    templatefile("${path.module}/values/prometheus-values.yaml", {
      storage_class_name     = var.storage_class_name
      prometheus_retention   = var.prometheus_retention
      prometheus_storage     = var.prometheus_storage_size
      grafana_admin_password = var.grafana_admin_password
      grafana_storage        = var.grafana_storage_size
    })
  ]

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  depends_on = [kubernetes_namespace.monitoring]
}
