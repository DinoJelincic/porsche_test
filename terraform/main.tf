module "vpc" {
    source = "./modules/networking/virtual_network"
    for_each = var.vpc
    name = each.key
    settings = each.value
  
}