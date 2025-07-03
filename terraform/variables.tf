variable "bastion_public_key" {
  
}
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
    cidr_block              = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
}

variable "igw" {
  type = map(object({
    vpc_id = string
    tags   = map(string)
  }))
}

variable "nat" {
  type = map(object({
    private_subnet = string
    tags           = map(string)
  }))
}

variable "route_tables" {
  description = "Route table configuration"
  type = map(object({
    vpc_id         = string
    gateway_id     = string
    nat_gateway_id = string
    route = list(object({
      cidr_block     = string
      gateway_id     = optional(string)
      nat_gateway_id = optional(string)
    }))
    tags = map(string)
  }))
}

variable "rt_association" {
  type = map(object({
    subnet_name      = string
    route_table_name = string
  }))
}

variable "bastion_sg" {
  type = map(object({
    vpc_id = string
    ingress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))  
}

variable "bastion" {
  type = map(object({
    instance_type = string
    subnet_id = string
    security_group = list(string)
    tags = map(string)
  }))
  
}

# variable "sg" {
#   type = map(object({
#     vpc_id = string
#     ingress = list(object({
#       from_port = number
#       to_port = number
#       protocol = string
#       cidr_blocks     = optional(list(string))
#       security_groups = optional(list(string))
#     }))
#     egress = list(object({
#       from_port = number
#       to_port = number
#       protocol = string
#       cidr_blocks = list(string)
#     }))
#     tags = map(string)
#   }))
  
# }

# variable "bucket" {
#   type = map(object({
#     tags = map(string)
#   }))
  
# }

# variable "endpoint" {
#   type = map(object({
#     vpc_id = string
#     private_route_table = list(string)
#     service_name = string
#     vpc_endpoint_type = string
#     tags = map(string)

#   }))
  
# }

# # variable "s3_policy" {
# #   type = map(object({
# #     bucket = string
# #     endpoint = string
# #     terraform_role_arn = string 
# #   }))
  
# # }
# variable "iam" {
#   type = map(object({
#     bucket = string

#   }))
  
# }

# # variable "compute" {
# #   type = map(object({
# #     instance_type = string
# #     subnet_id = string
# #     security_group = list(string)
# #     instance_profile_name = string
# #     tags = map(string)
# #   }))
  
# # }

# # variable "bastion" {
# #   type = map(object({
# #   }))
  
# # }