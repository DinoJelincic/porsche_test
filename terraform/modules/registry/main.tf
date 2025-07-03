resource "aws_ecr_repository" "ecr" {
  name                 = var.name
  image_tag_mutability = var.settings.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.settings.tags
}