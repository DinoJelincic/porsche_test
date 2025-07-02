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
    tags = each.value.tags
    vpc_id = module.vpc[each.value.vpc_id].id
}