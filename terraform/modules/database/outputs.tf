output "db-host" {
  value = kubernetes_deployment.database.spec.0.template.0.spec.0.container.0.name
}

output "db-service-name" {
  value = kubernetes_service.database.metadata.0.name
}

output "phpmyadmin-service-name" {
  value = kubernetes_service.phpmyadmin.metadata.0.name
}