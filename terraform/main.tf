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
    source = "./modules/networking/igw"
    for_each = var.igw
    vpc_id = module.vpc[each.value.vpc_id].id
    settings = each.value 
    depends_on = [ module.vpc, module.subnets ]
}

module "nat" {
    source = "./modules/networking/nat"
    for_each = var.nat
    subnet_id = module.subnets[each.value.private_subnet].id
    settings = each.value
    depends_on = [ module.vpc, module.subnets ]
  
}

module "route_table" {
  source           = "./modules/networking/route_table"
  for_each         = var.route_table
  vpc_id           = module.vpc[each.value.vpc_id].id
  gateway_id      = { for k, igw in module.igw : k => igw.id }
  nat_gateway_id  = { for k, nat in module.nat : k => nat.id }
  settings         = each.value
  depends_on       = [module.igw, module.nat]
  
}


resource "aws_route_table_association" "public_assoc" {
  for_each = var.rt_association
  subnet_id      = module.subnets[each.value.subnet_name].id
  route_table_id = module.route_table[each.value.route_table_name].id
  depends_on = [ module.route_table, module.subnets ]
}