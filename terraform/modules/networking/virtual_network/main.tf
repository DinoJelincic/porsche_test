resource "aws_vpc" "vpc" {
    lifecycle {
      ignore_changes = [ tags ]
    }
  cidr_block       = var.settings.cidr_block
  instance_tenancy = var.settings.instance_tenancy
  enable_dns_hostnames = var.settings.enable_dns_hostnames
  enable_dns_support = var.settings.enable_dns_support

  tags = var.settings.tags
}