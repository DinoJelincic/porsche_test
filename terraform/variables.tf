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
    #availability_zone       = string
    cidr_block = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
}

variable "igw_tags" {
  description = "Internet Gateway tags"
}

variable "nat" {
  type = map(object({
    private_subnet = string
    tags = map(string)
  }))
  
}

# variable "nat" {
#   description = "Nat Gateway configuration"
#   type = map(object({
#     private_subnet = string 
#     tags = map(string)
#   }))
  
# }

variable "route_table" {
  description = "Route table configuration"
  type = map(object({
    vpc_id = string
    route = list(object({
      cidr_block = string
      gateway_id = optional(string)
      nat_gateway_id = optional(string)
    }))
    tags = map(string)
  }))
  
}

variable "rt_association" {
  description = "Route Table association configuration"
  type = map(object({
    subnet_name = string
    route_table_name = string
  }))
  
}