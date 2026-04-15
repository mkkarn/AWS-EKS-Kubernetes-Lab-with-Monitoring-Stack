################################################################################
# Argo CD Module
################################################################################

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  timeout    = 600

  # For lab purposes, we'll use a simple password.
  # In production, use a more secure method.
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = "$2a$10$5v8Zz1g2R2L2i2i2i2i2u2i2i2i2i2i2i2i2i2i2i2i2i2i2i2i2i2i2" # Example: 'password'
  }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}
