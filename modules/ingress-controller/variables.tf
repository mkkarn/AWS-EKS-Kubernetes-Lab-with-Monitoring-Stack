variable "namespace" {
  description = "Kubernetes namespace for ingress controller"
  type        = string
  default     = "ingress-nginx"
}

variable "chart_version" {
  description = "Version of ingress-nginx Helm chart"
  type        = string
  default     = "4.8.3"
}

variable "replica_count" {
  description = "Number of ingress controller replicas"
  type        = number
  default     = 2
}

variable "enable_service_monitor" {
  description = "Enable ServiceMonitor for Prometheus"
  type        = bool
  default     = true
}
