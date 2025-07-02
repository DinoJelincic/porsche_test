variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc" {
  description = "Network configuration"
  type = map(object({
    cidr_block           = string
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
    cidr_block = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
}

variable "igw" {
  type = object({
    vpc_id = string
    tags   = map(string)
  })
}
variable "nat" {
  type = object({
    private_subnet = string
    tags = map(string) 
  }) 
}

variable "route_tables" {
  description = "Route table configuration"
  type = map(object({
    vpc_id = string
    gateway_id = string
    nat_gateway_id = string
    route = object({
      cidr_block      = string
      gateway_id      = optional(string)
      nat_gateway_id  = optional(string)
    })
    tags = map(string)
  }))
}

# variable "rt_association" {
#   type = map(object({
#     subnet_name       = string
#     route_table_name  = string
#   }))
# }