output "namespace" {
  description = "The namespace where monitoring stack is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_service" {
  description = "Prometheus service name"
  value       = "kube-prometheus-stack-prometheus"
}

output "grafana_service" {
  description = "Grafana service name"
  value       = "kube-prometheus-stack-grafana"
}

output "alertmanager_service" {
  description = "Alertmanager service name"
  value       = "kube-prometheus-stack-alertmanager"
}
