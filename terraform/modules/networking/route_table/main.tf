resource "aws_route_table" "route" {
  vpc_id = var.vpc_id

  dynamic route {
    for_each = try(var.settings.route, null) == null ? [] : var.settings.route
    content {
        cidr_block = route.value.cidr_block
        gateway_id = lookup(route.value.gateway_id, null)
        nat_gateway_id = lookup(route.value.nat_gateway_id, null)
    }
  }
  tags = var.settings.tags
}