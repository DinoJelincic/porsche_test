resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.route != null ? [var.route] : []
    content {
      cidr_block = route.value.cidr_block
      gateway_id     = try(route.value.gateway_id, null)
      nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
  }

  tags = var.tags
}
