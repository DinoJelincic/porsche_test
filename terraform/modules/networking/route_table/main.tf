resource "aws_route_table" "route" {
  vpc_id = var.vpc_id

  dynamic route {
    for_each = try(var.settings.route, null) == null ? [] : var.settings.route
    content {
        cidr_block = try(route.value.cidr_block, null)
        gateway_id = try(var.gateway_id, null)
        nat_gateway_id = try(var.nat_gateway_id, null)
        #gateway_id = try(route.value.gateway_id, null)
        #nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
  }
  tags = var.settings.tags
}