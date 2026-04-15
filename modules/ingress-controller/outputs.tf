output "namespace" {
  description = "The namespace where ingress controller is deployed"
  value       = kubernetes_namespace.ingress_nginx.metadata[0].name
}

output "controller_service" {
  description = "Ingress controller service name"
  value       = "ingress-nginx-controller"
}
