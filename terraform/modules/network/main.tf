terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name = "example-ingress"
    namespace = var.db-namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    default_backend {
      service {
        name = var.phpmyadmin-service
        port {
          number = 8081
        }
      }
    }

    rule {
      host = "php.myadmin"
      http {
        path {
          path = "/"
          backend {
            service {
              name = var.phpmyadmin-service
              port {
                number = 8081
              }
            }
          }
        }
      }
    }
  }
}