terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_deployment" "webapp" {
  metadata {
    name      = "webapp-deployment"
    namespace = var.webapp-namespace
  }
  spec {
    replicas = var.webapp-replicas
    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }
      spec {
        container {
          image = var.webapp-dockerfile-path
          name  = "${var.webapp-container-name}-container"
          port {
            container_port = 443
          }
        }
      }
    }
  }
  /*
    env = [ "INSTANCIA=${count.index + 1}","DB_USER=${var.db-user}","DB_PASS=${var.db-pass}",
    "DB_HOST=${var.db-host}","REDIS_HOST=${var.redis-host}" ]

volumes {
      container_path = "/home/node/app/src/img/"
      volume_name = var.shared-volume
    }*/
}

resource "kubernetes_service" "webapp" {
  metadata {
    name      = "webapp"
    namespace = var.webapp-namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.webapp.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}
