################################################################################
# ELK Stack Module
# Deploys Elasticsearch, Logstash, Kibana, and Filebeat
################################################################################

locals {
  namespace = var.namespace
}

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "logging" {
  metadata {
    name = local.namespace

    labels = {
      name        = local.namespace
      environment = var.environment
    }
  }
}

################################################################################
# Elasticsearch
################################################################################

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.elastic_version
  namespace  = kubernetes_namespace.logging.metadata[0].name

  timeout = 900

  values = [
    templatefile("${path.root}/modules/elk-stack/values/elasticsearch-values.yaml", {
      replicas           = var.elasticsearch_replicas
      storage_size       = var.elasticsearch_storage_size
      storage_class_name = var.storage_class_name
      java_opts          = var.elasticsearch_java_opts
    })
  ]

  depends_on = [kubernetes_namespace.logging]
}

################################################################################
# Kibana
################################################################################

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = var.elastic_version
  namespace  = kubernetes_namespace.logging.metadata[0].name

  timeout = 600

  values = [file("${path.root}/modules/elk-stack/values/kibana-values.yaml")]

  depends_on = [helm_release.elasticsearch]
}

################################################################################
# Logstash
################################################################################

resource "helm_release" "logstash" {
  name       = "logstash"
  repository = "https://helm.elastic.co"
  chart      = "logstash"
  version    = var.elastic_version
  namespace  = kubernetes_namespace.logging.metadata[0].name

  timeout = 600

  values = [file("${path.root}/modules/elk-stack/values/logstash-values.yaml")]

  depends_on = [helm_release.elasticsearch]
}

################################################################################
# Filebeat
################################################################################

resource "helm_release" "filebeat" {
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  version    = var.elastic_version
  namespace  = kubernetes_namespace.logging.metadata[0].name

  timeout = 600

  values = [file("${path.root}/modules/elk-stack/values/filebeat-values.yaml")]

  depends_on = [helm_release.elasticsearch]
}
