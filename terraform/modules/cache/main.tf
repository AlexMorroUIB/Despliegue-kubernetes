terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Pulls the image
resource "docker_image" "redis" {
  name = "redis:7"
}
resource "docker_image" "phpredisadmin" {
  name = "erikdubbelboer/phpredisadmin:latest"
}

# Redis master
resource "docker_container" "redis-master" {
  image = docker_image.redis.image_id
  name  = "${var.redis-container-name}-master"

  entrypoint = [ "redis-server" ]

  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
#Redis slave
resource "docker_container" "redis-slave" {
  count = var.cache-slaves
  image = docker_image.redis.image_id
  name  = "${var.redis-container-name}-slave-${count.index + 1}"
  
  entrypoint = [ "redis-server", "--slaveof", "${docker_container.redis-master.name}", "6379" ]

  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
resource "docker_container" "phpredisadmin" {
  image = docker_image.phpredisadmin.image_id
  name  = var.phpredis-container-name
  env = [ "REDIS_1_HOST=${docker_container.redis-master.name}" ]
  ports {
    internal = 80
    external = var.phpredisadmin-port
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
