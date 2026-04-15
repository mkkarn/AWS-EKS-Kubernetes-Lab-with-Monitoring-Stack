################################################################################
# NGINX Ingress Controller Module
################################################################################

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  timeout = 600

  values = [
    <<-EOF
    controller:
      replicaCount: ${var.replica_count}
      
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 500m
          memory: 512Mi
      
      service:
        type: LoadBalancer
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: nlb
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
      
      metrics:
        enabled: true
        serviceMonitor:
          enabled: ${var.enable_service_monitor}
          namespace: monitoring
      
      admissionWebhooks:
        enabled: true
      
      config:
        use-forwarded-headers: "true"
        compute-full-forwarded-for: "true"
        use-proxy-protocol: "false"
    
    defaultBackend:
      enabled: true
      resources:
        requests:
          cpu: 10m
          memory: 20Mi
        limits:
          cpu: 100m
          memory: 64Mi
    EOF
  ]

  depends_on = [kubernetes_namespace.ingress_nginx]
}
