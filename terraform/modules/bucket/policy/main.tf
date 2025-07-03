resource "aws_s3_bucket_policy" "restricted_policy" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowTerraformRoleFullAccess",
        Effect = "Allow",
        Principal = {
          AWS = var.terraform_role_arn
        },
        Action = [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObject"
        ],
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      },
      {
        Sid = "DenyAccessExceptFromVpcEndpoint",
        Effect = "Deny",
        Principal = "*",
        Action = "s3:*",
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ],
        Condition = {
          StringNotEquals = {
            "aws:SourceVpce" = var.vpc_endpoint_id
          }
        }
      }
    ]
  })
}
