variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc" {
  description = "Network configuration"
  type = map(object({
    cidr_block           = string
    region               = string
    instance_tenancy     = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
    tags                 = map(string)
  }))
}

variable "subnets" {
  description = "Subnet configuration"
  type = map(object({
    vpc_id                  = string
    cidr_block              = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
}
