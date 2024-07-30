resource "aws_iam_user" "admin_user" {
  name = "admin_user_${random_string.uid.result}"
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "Allows listing and reading objects in the S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
        ]
        Resource = aws_s3_bucket.customer_info.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = "${aws_s3_bucket.customer_info.arn}/*"
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

resource "aws_iam_user_policy_attachment" "s3_read_attachment" {
  user       = aws_iam_user.admin_user.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_access_key" "admin_key" {
  user = aws_iam_user.admin_user.name
}


