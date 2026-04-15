output "namespace" {
  description = "The namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}
