module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.19.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  create_cloudwatch_log_group = false

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    "${local.name}-eks" = {
      instance_types   = ["c5.xlarge"]
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

resource "aws_iam_role" "irsa_role" {
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

resource "aws_iam_role_policy" "irsa_policy" {
  name = "eks-irsa-policy"
  role = aws_iam_role.irsa_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_images.bucket}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_images.bucket}/*"
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

resource "time_sleep" "wait" {
  create_duration = "30s"

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "wiz_namespace" {
  metadata {
    name = "wiz"
    labels = {
      name = "wiz"
    }
  }

  depends_on = [time_sleep.wait]
}

resource "kubernetes_secret" "sensor_image_pull" {
  metadata {
    name      = "sensor-image-pull"
    namespace = "wiz"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "wizio.azurecr.io/sensor" = {
          username = var.wiz_sensor_registry_username
          password = var.wiz_sensor_registry_password
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [kubernetes_namespace.wiz_namespace]
}

resource "kubernetes_secret" "wiz_api_token" {
  metadata {
    name      = "wiz-api-token"
    namespace = "wiz"
  }

  data = {
    clientId    = var.wiz_k8s_integration_client_id
    clientToken = var.wiz_k8s_integration_client_secret
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.wiz_namespace]
}

resource "helm_release" "wiz_integration" {
  name             = "wiz-integration"
  repository       = "https://wiz-sec.github.io/charts"
  chart            = "wiz-kubernetes-integration"
  namespace        = "wiz"
  create_namespace = false

  values = [
    <<EOF
global:
  wizApiToken:
    secret:
      create: false
      name: wiz-api-token
      clientEndpoint: ""
 
wiz-kubernetes-connector:
  enabled: true
  autoCreateConnector:
    apiServerEndpoint: "${module.eks.cluster_endpoint}"
    connectorName: "${module.eks.cluster_name}" 
    clusterFlavor: EKS
  broker:
    enabled: true
 
wiz-sensor:
  enabled: true
  imagePullSecret:
    create: false
    name: sensor-image-pull
 
wiz-admission-controller:
  enabled: true
  kubernetesAuditLogsWebhook:
    enabled: true
  imageIntegrityWebhook:
    enabled: false
    EOF
  ]

  depends_on = [kubernetes_secret.sensor_image_pull, kubernetes_secret.wiz_api_token]
}

resource "helm_release" "ecomm_app" {
  name      = "ecomm-app"
  chart     = "../helm/ecomm-app"
  namespace = "default"

  values = [
    file("../helm/ecomm-app/values.yaml")
  ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.irsa_role.arn
  }

  depends_on = [time_sleep.wait]
}

