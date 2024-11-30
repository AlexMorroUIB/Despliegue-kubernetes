resource "kubernetes_config_map" "init-file" {
  metadata {
    name = "init-file"
    namespace = kubernetes_namespace.database.metadata.0.name
  }

  data = {
    "init.sql" = file("../conf-files/init.sql")
  }
}