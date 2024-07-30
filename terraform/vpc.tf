module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.zones
  public_subnets  = ["10.0.54.0/24", "10.0.56.0/24"]
  private_subnets = ["10.0.55.0/24", "10.0.57.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"          = 1
  }
}
