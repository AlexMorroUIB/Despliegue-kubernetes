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
  }

  spec {
    default_backend {
      service {
        name = "phpmyadmin"
        port {
          number = 8081
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = var.db-service
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