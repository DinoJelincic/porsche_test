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
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.id
  tags = var.igw_tags

}

resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "nat" {
  for_each = var.nat
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = module.subnets[each.value.private_subnet].id
  tags = each.value
}


module "route_table" {
  source           = "./modules/networking/route_table"
  for_each         = var.route_table
  vpc_id           = module.vpc[each.value.vpc_id].id
  gateway_id      = aws_internet_gateway.igw.id
  nat_gateway_id  = aws_nat_gateway.nat.id
  settings         = each.value
  depends_on       = [aws_internet_gateway.igw, aws_nat_gateway.nat]
  
}


resource "aws_route_table_association" "public_assoc" {
  for_each = var.rt_association
  subnet_id      = module.subnets[each.value.subnet_name].id
  route_table_id = module.route_table[each.value.route_table_name].id
  depends_on = [ module.route_table, module.subnets ]
}