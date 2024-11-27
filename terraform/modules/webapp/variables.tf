variable "webapp-container-name" {
  type = string
  default = "webapp"
}

variable "webapp-namespace" {
  type = string
}

variable "webapp-dockerfile-path" {
  type = string
  default = "../../../WebApp/"
}

variable "webapp-replicas" {
  type = string
  default = "2"
}

variable "db-host" {
  type = string
  default = "mariadb"
}

variable "redis-host" {
  default = "redis"
}

variable "db-user" {
  type = string
}

variable "db-pass" {
  type = string
}

variable "shared-volume" {
  type = string
  default = "shared-volume"
}