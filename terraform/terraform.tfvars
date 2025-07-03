region = "eu-central-1"
vpc = {
  "porsche_vpc" = {
    cidr_block           = "10.10.0.0/16"
    instance_tenancy     = "default"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name = "porsche_vpc"
    }
  }
}

subnets = {
  "public_subnet" = {
    vpc_id                  = "porsche_vpc"
    map_public_ip_on_launch = true
    cidr_block              = "10.10.1.0/24"
    tags = {
      Name = "public_subnet"
    }
  }
  private_subnet = {
    vpc_id                  = "porsche_vpc"
    map_public_ip_on_launch = false
    cidr_block              = "10.10.100.0/24"
    tags = {
      Name = "private_subnet"
    }
  }
}

igw = {
  "porsche_igw" = {
    vpc_id = "porsche_vpc"
    tags = {
      Name = "porsche_igw"
    }
  }
}

nat = {
  "porsche_nat" = {
    private_subnet = "private_subnet"
    tags = {
      Name = "porsche_nat"
    }
  }
}

route_tables = {
  "public" = {
    vpc_id         = "porsche_vpc"
    gateway_id     = "porsche_igw"
    nat_gateway_id = "porsche_nat"
    route = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "porsche_igw"
      }
    ]
    tags = {
      Name = "public_route_table"
    }
  }
  "private" = {
    vpc_id         = "porsche_vpc"
    gateway_id     = "porsche_igw"
    nat_gateway_id = "porsche_nat"
    route = [
      {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "porsche_nat"
      }
    ]
    tags = {
      Name = "private_route_table"
    }
  }

}

rt_association = {
  "public" = {
    subnet_name      = "public_subnet"
    route_table_name = "public"
  }
  "private" = {
    subnet_name      = "private_subnet"
    route_table_name = "private"
  }
}

sg = {
  ec2_sg = {
    vpc_id = "porsche_vpc"
    ingress = [
      {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        protocol    = "tcp"
        to_port     = 80
      },
      {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 443
        protocol    = "tcp"
        to_port     = 443
      },
      {
        cidr_blocks = ["93.140.103.146/32"]
        from_port   = 22
        protocol    = "tcp" 
        to_port     = 22
      }
    ]
    egress = [
      {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
      }
    ]
    tags = {
      Name = "ec2_sg"
    }
  }
}

bucket = {
  "porsche-bucket" = {
    tags = {
      Name = "porsche-bucket"
    }
    
  }
}

endpoint = {
  "s3_endpoint" = {
    vpc_id = "porsche_vpc"
    private_route_table = ["private"]
    service_name = "com.amazonaws.eu-central-1.s3"
    vpc_endpoint_type = "Gateway"
    tags = {
      Name = "s3_porsche_endpoint"
    }
    
  }
}
# s3_policy = {
#   "bucket_policy" = {
#     bucket = "porsche-bucket"
#     endpoint = "s3_endpoint"
#     terraform_role_arn = "arn:aws:iam::339712870085:role/porsche_role_github"
    
#   }
# }

iam = {
  "ec2_s3_access_role" = {
    bucket = "porsche-bucket"
    
  }
}

compute = {
  "porsche_ec2" = {
    instance_type = "t2.micro"
    subnet_id = "private_subnet"
    security_group = ["ec2_sg"] 
    instance_profile_name = "ec2_s3_access_role"
    tags = {
      Name = "porsche_ec2"
    }
  }
}
