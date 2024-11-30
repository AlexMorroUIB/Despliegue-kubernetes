/*resource "kubernetes_persistent_volume_claim" "init-pvc" {
  metadata {
    name = "init-pvc"
    namespace = "database-ns"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "50Ki"
      }
    }
    storage_class_name = "local"
    volume_name = kubernetes_persistent_volume.init-pv.metadata.0.name
  }
}

resource "kubernetes_persistent_volume" "init-pv" {
  metadata {
    name = "init-pv"
  }

  spec {
    capacity = {
      storage = "100Ki"
    }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "local"

    persistent_volume_source {
      host_path {
        path = var.init-path
      }
    }
  }
}*/

/*resource "docker_volume" "db-volume" {
  name = "db-${terraform.workspace}"
}

resource "docker_volume" "shared-volume" {
  name = "shared-volume"
  driver_opts = {
    type = "none"
    o = "bind"
    device = abspath("../shared/")
  }
}

resource "docker_volume" "grafana-volume" {
  name = "grafana-${terraform.workspace}"
}*/