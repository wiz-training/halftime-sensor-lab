data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "tls_certificate" "default" {
  url = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
}

data "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = "default"
  }
  depends_on = [helm_release.ecomm_app]
}
