# resource "aws_s3_bucket_policy" "policy" {
#   bucket = var.bucket_id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid = "AllowAccessFromVpcEndpoint",
#         Effect = "Allow",
#         Principal = "*",
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetBucketPolicy",
#           "s3:PutBucketPolicy"
#         ],
#         Resource = [
#           var.bucket_arn,
#           "${var.bucket_arn}/*"
#         ],
#         Condition = {
#           StringEquals = {
#             "aws:sourceVpce" = var.vpc_endpoint_id
#           }
#         }
#       },
#       {
#         Sid = "AllowEC2RoleFullAccess",
#         Effect = "Allow",
#         Principal = {
#           AWS = var.ec2_role_arn
#         },
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetBucketPolicy",
#           "s3:PutBucketPolicy"
#         ],
#         Resource = [
#           var.bucket_arn,
#           "${var.bucket_arn}/*"
#         ]
#       }
#     ]
#   })
# }
