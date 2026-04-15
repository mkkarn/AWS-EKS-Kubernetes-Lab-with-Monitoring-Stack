variable "namespace" {
  description = "Kubernetes namespace for ELK stack"
  type        = string
  default     = "logging"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "elastic_version" {
  description = "Version of Elastic Helm charts"
  type        = string
  default     = "8.5.1"
}

variable "elasticsearch_replicas" {
  description = "Number of Elasticsearch replicas"
  type        = number
  default     = 1
}

variable "elasticsearch_storage_size" {
  description = "Elasticsearch storage size"
  type        = string
  default     = "30Gi"
}

variable "elasticsearch_java_opts" {
  description = "Elasticsearch JVM options"
  type        = string
  default     = "-Xmx1g -Xms1g"
}

variable "storage_class_name" {
  description = "Storage class name for persistent volumes"
  type        = string
  default     = "gp2"
}
