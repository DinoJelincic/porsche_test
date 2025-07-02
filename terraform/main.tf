module "vpc" {
  source  = "./modules/networking/virtual_network"
  for_each = var.vpc
  name     = each.key
  settings = each.value
}

module "subnets" {
  source  = "./modules/networking/subnets"
  for_each = var.subnets
  vpc_id             = module.vpc[each.value.vpc_id].id
  availability_zone = element(data.aws_availability_zones.azs.names,index(keys(var.subnets), each.key))
  settings           = each.value
  depends_on = [module.vpc]
}

module "igw" {
  source  = "./modules/networking/igw"
  vpc_id  = module.vpc[var.igw.vpc_id].id
  tags    = var.igw.tags
  depends_on = [ module.subnets ]
}

module "nat" {
    source = "./modules/networking/nat"
    private_subnet = module.subnets[var.nat.private_subnet].id
    tags = var.nat.tags
    depends_on = [ module.subnets ]
}

module "route_table" {
  source   = "./modules/networking/route_table"
  for_each = var.route_table
  vpc_id         = module.vpc[each.value.vpc_id].id
  gateway_id     = try(module.igw[each.value.gateway_id].id, null)
  nat_gateway_id = try(module.nat[each.value.nat_id].id, null)
  cidr_block     = each.value.cidr_block
  tags           = each.value.tags
  depends_on = [module.nat, module.igw]
}

resource "aws_route_table_association" "assoc" {
  for_each = var.rt_association
  subnet_id      = module.subnets[each.value.subnet_name].id
  route_table_id = module.route_table[each.value.route_table_name].id
  depends_on = [module.route_table, module.subnets]
}
