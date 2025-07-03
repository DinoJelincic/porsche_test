resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = var.settings.service_name
  vpc_endpoint_type = var.settings.vpc_endpoint_type
  route_table_ids   = var.route_table_ids

  tags = var.settings.tags
}
