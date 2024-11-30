output "redis-host" {
    value = docker_container.redis-master.name
}