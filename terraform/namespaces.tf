resource "kubernetes_namespace" "webapp" {
  metadata {
    name = "webapp-ns"
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = "database-ns"
  }
}