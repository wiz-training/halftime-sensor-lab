variable "region" {
  default = "us-east-1"
  type    = string
}

variable "wiz_k8s_integration_client_id" {
  type    = string
  default = null
}

variable "wiz_k8s_integration_client_secret" {
  type      = string
  default   = null
  sensitive = true
}

variable "wiz_sensor_registry_username" {
  type    = string
  default = null
}

variable "wiz_sensor_registry_password" {
  type      = string
  default   = null
  sensitive = true
}

variable "cluster_name" {
  type    = string
  default = "ecomm-app-cluster"
}

variable "profile" {
  type    = string
  default = "default"
}
