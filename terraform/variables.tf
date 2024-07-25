variable "wiz_k8s_integration_client_id" {
  description = "The client ID for the Kubernetes integration"
  sensitive   = false
}

variable "wiz_k8s_integration_client_secret" {
  description = "The client secret for the Kubernetes integration"
  sensitive   = true
}

variable "wiz_sensor_registry_username" {
  description = "The username for the Wiz Sensor registry"
  sensitive   = false
}

variable "wiz_sensor_registry_password" {
  description = "The password for the Wiz Sensor registry"
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  sensitive   = false
  default     = "ecomm-app"
}
