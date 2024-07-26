variable "region" {
  default = "us-east-1"
  type    = string
}

variable "wiz_client_id" {
  type    = string
  default = null
}

variable "wiz_client_secret" {
  type    = string
  default = null
}

variable "cluster_name" {
  type    = string
  default = "ecomm-app-cluster"
}

variable "profile" {
  type    = string
  default = "default"
}

locals {
  name         = var.cluster_name
  region       = var.region
  cluster_name = local.name
  profile      = var.profile
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
}

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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.19.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    "${local.name}-eks" = {
      instance_types   = ["t3.medium"]
      min_size         = 1
      max_size         = 1
      desired_size     = 1
      desired_capacity = 1
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

data "tls_certificate" "default" {
  url = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "default" {
  name = "ecomm-eks-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = ""
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.default.identity[0].oidc[0].issuer, "https://", "")}"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.default.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:default:ecomm-app-sa"
          "${replace(data.aws_eks_cluster.default.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "default" {
  name = "eks-irsa-policy"
  role = aws_iam_role.default.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::testbucket098098234"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets"
        ],
        Resource = "*"
      }
    ]
  })
}

output "update_kubectl" {
  value = "AWS_PROFILE='${local.profile}' aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name}"
}
