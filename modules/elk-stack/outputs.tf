output "namespace" {
  description = "The namespace where ELK stack is deployed"
  value       = kubernetes_namespace.logging.metadata[0].name
}

output "elasticsearch_endpoint" {
  description = "Elasticsearch endpoint"
  value       = "http://elasticsearch-master.${local.namespace}.svc.cluster.local:9200"
}

output "kibana_endpoint" {
  description = "Kibana endpoint"
  value       = "http://kibana-kibana.${local.namespace}.svc.cluster.local:5601"
}

output "logstash_endpoint" {
  description = "Logstash endpoint"
  value       = "logstash-logstash.${local.namespace}.svc.cluster.local:5044"
}
