resource "aws_route_table" "route" {
  vpc_id = var.vpc_id
  tags   = var.settings.tags

  dynamic "route" {
    for_each = var.settings.route != null ? var.settings.route : []

    content {
      cidr_block = route.value.cidr_block

      gateway_id = (
        contains(keys(route.value), "gateway_id") && route.value.gateway_id != null
      ) ? var.gateway_id : null

      nat_gateway_id = (
        (!contains(keys(route.value), "gateway_id") || route.value.gateway_id == null)
        && contains(keys(route.value), "nat_gateway_id") && route.value.nat_gateway_id != null
      ) ? var.nat_gateway_id : null
    }
  }
}
