resource "aws_iam_role" "default" {
  name = "ecomm-eks-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = ""
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::534846779113:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/40E581ABCA53FE1D44E640703C5CF2DF"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "oidc.eks.us-east-1.amazonaws.com/id/40E581ABCA53FE1D44E640703C5CF2DF:sub" = "system:serviceaccount:default:ecomm-app-sa"
          "oidc.eks.us-east-1.amazonaws.com/id/40E581ABCA53FE1D44E640703C5CF2DF:aud" = "sts.amazonaws.com"
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
