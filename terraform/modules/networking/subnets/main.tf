resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.settings.cidr_block
  map_public_ip_on_launch = var.settings.map_public_ip_on_launch
  tags                    = var.settings.tags
  availability_zone       = var.settings.aws_availability_zone
}
