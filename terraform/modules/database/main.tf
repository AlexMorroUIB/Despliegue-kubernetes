terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = "database-deployment"
    namespace = var.db-namespace
  }
  spec {
    selector {
      match_labels = {
        app = "database"
      }
    }
    template {
      metadata {
        labels = {
          app = "database"
        }
      }
      spec {
        container {
          image = var.db-image
          name  = "${var.db-container-name}-container"
          port {
            container_port = 3306
          }
          env {
            name  = "MARIADB_ROOT_PASSWORD"
            value = var.db_password
          }
          volume_mount {
            name       = "init"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }
        container {
          image = "phpmyadmin:5"
          name  = "${var.phpmyadmin-container-name}-container"
          port {
            container_port = 80
          }
          env {
            name  = "PMA_HOST"
            value = "${var.db-container-name}-container"
          }
          env {
            name  = "PMA_PORT"
            value = "3306"
          }
        }
        volume {
          name = "init"
          config_map {
            name = var.db-init-file
          }
        }
          /*volumes {
    container_path = "/var/lib/mysql"
    volume_name    = var.db-volume
  }
  # archivo init.sql para empezar con datos
  volumes {
    host_path      = var.db-init-file
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }*/
      }
    }
  }
}

resource "kubernetes_service" "database" {
  metadata {
    name      = "database"
    namespace = var.db-namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.database.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      port        = 3306
      target_port = 3306
    }
  }
}

resource "kubernetes_service" "phpmyadmin" {
  metadata {
    name      = "phpmyadmin"
    namespace = var.db-namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.database.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      # internal = 80
      port        = 8081
      target_port = 80
    }
  }
}
