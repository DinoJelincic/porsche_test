resource "random_id" "random_bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${random_id.random_bucket.hex}"
  tags = var.settings.tags
}
