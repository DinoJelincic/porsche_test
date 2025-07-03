module "vpc" {
  source   = "./modules/networking/virtual_network"
  for_each = var.vpc
  name     = each.key
  settings = each.value
}

module "subnets" {
  source            = "./modules/networking/subnets"
  for_each          = var.subnets
  vpc_id            = module.vpc[each.value.vpc_id].id
  availability_zone = element(data.aws_availability_zones.azs.names, index(keys(var.subnets), each.key))
  settings          = each.value
  depends_on        = [module.vpc]
}

module "igw" {
  source   = "./modules/networking/igw"
  for_each = var.igw
  vpc_id   = module.vpc[each.value.vpc_id].id
  tags     = each.value.tags
}

module "nat" {
  source         = "./modules/networking/nat"
  for_each       = var.nat
  private_subnet = module.subnets[each.value.private_subnet].id
  tags           = each.value.tags
}


module "route_table" {
  source         = "./modules/networking/route_table"
  for_each       = var.route_tables
  settings       = each.value
  vpc_id         = module.vpc[each.value.vpc_id].id
  gateway_id     = contains(keys(module.igw), each.value.gateway_id) ? module.igw[each.value.gateway_id].id : null
  nat_gateway_id = contains(keys(module.nat), each.value.nat_gateway_id) ? module.nat[each.value.nat_gateway_id].id : null
  depends_on     = [module.igw, module.nat]
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = var.rt_association
  subnet_id      = module.subnets[each.value.subnet_name].id
  route_table_id = module.route_table[each.value.route_table_name].id
  depends_on     = [module.route_table, module.subnets]
}

module "bastion_sg" {
  source = "./modules/security/sg/bastion"
  for_each = var.bastion_sg
  name = each.key
  settings = each.value
  vpc_id = module.vpc[each.value.vpc_id].id
  depends_on = [ module.vpc ]
  
}

module "bastion" {
  source = "./modules/compute/bastion"
  for_each = var.bastion
  settings = each.value
  ami_id = data.aws_ami.ubuntu.id
  subnet_id = module.subnets[each.value.subnet_id].id
  vpc_security_group_ids = [for sg in each.value.security_group : module.bastion_sg[sg].id]
  bastion_public_key = var.bastion_public_key
  depends_on = [ module.vpc ]
}

module "ec2_sg" {
  source = "./modules/security/sg/ec2"
  for_each = var.ec2_sg
  name = each.key
  settings = each.value
  vpc_id = module.vpc[each.value.vpc_id].id
  depends_on = [ module.vpc ]
  
}

module "endpoint" {
  source = "./modules/networking/endpoint"
  for_each        = var.endpoint
  settings        = each.value
  vpc_id          = module.vpc[each.value.vpc_id].id
  region          = var.region
  route_table_ids = [for name in each.value.private_route_table : module.route_table[name].id]
  depends_on = [ module.vpc, module.bucket ]

}

module "bucket" {
  source = "./modules/bucket"
  for_each = var.bucket
  name = each.key
  settings = each.value
  
}

module "iam" {
  source = "./modules/security/iam"
  for_each = var.iam
  name = each.key
  bucket_arn = module.bucket[each.value.bucket].arn
}


module "compute" {
  source = "./modules/compute/ec2"
  for_each = var.ec2
  settings = each.value
  ami_id = data.aws_ami.ubuntu.id
  subnet_id = module.subnets[each.value.subnet_id].id
  vpc_security_group_ids = [for sg in each.value.security_group : module.ec2_sg[sg].id]
  instance_profile = module.iam[each.value.instance_profile_name].instance_profile_name
  ec2_public_key = var.ec2_public_key
  depends_on = [ module.iam, module.vpc ]
  
}

module "s3_policy" {
  source = "./modules/bucket/policy"
  for_each = var.s3_policy
  bucket_arn = module.bucket[each.value.bucket].arn
  bucket_id = module.bucket[each.value.bucket].id
  terraform_role_arn = each.value.terraform_role_arn
  vpc_endpoint_id = module.endpoint[each.value.endpoint].id
  ec2_role_arn = module.iam[each.value.iam].arn

  
}

module "alb" {
  source = "./modules/compute/alb"
  for_each = var.alb
  name = each.key
  settings = each.value
  vpc_id = module.vpc[each.value.vpc].id
  public_subnets_id = [module.subnets[each.value.public_subnet].id]
  alb_sg_id = [for sg in each.value.security_group : module.bastion_sg[sg].id]
  depends_on = [ module.subnets ]
  
}





# # module "bastion" {
# #   source = "./modules/compute/bastion"
# #   for_each = var.bastion
# #   settings = each.value
# #   ami_id = data.aws_ami.ubuntu.id
# #   subnet_id = module.subnets[each.value.subnet_id].id


  
# # }