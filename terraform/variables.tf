variable "region" {
    type = string
    description = "AWS region in which resources will be deployed"
}
variable "vpc" {
    type = map(object({
      cidr_block = string
      region = string
      instance_tenancy = string
      enable_dns_hostnames = bool
      enable_dns_support = bool
      tags = map(string) 
    }))
  
}