locals {
  name         = var.cluster_name
  region       = var.region
  cluster_name = local.name
  profile      = var.profile
}

locals {
  zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
}
