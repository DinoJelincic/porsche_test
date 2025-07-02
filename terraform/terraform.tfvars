region = "eu-central-1"
vpc = {
  "porsche_vpc" = {
    cidr_block = "10.10.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "porsche_vpc"
    }
  }
}

subnets = {
  "public_subnet" = {
    vpc_id = "porsche_vpc"
    map_public_ip_on_launch = true
    cidr_block = "10.10.1.0/24"
    tags = {
      Name = "public_subnet"
    }
  }
  private_subnet = {
    vpc_id = "porsche_vpc"
    map_public_ip_on_launch = false
    cidr_block = "10.10.100.0/24"
    tags = {
      Name = "private_subnet"
    }
  }
}

igw = {
  vpc_id = "porsche_vpc"
  tags = {
    Name = "porsche_igw"
  }
}

nat = {
  private_subnet = "private_subnet"
  tags = {
    Name = "porsche_nat"
  }
}

route_table = {
  private = {
    vpc_id = "porsche_vpc"
    route = [
      {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "porsche_nat"
      }
    ]
    tags = {
      Name = "private_rt"
    }
  }
  public = {
    vpc_id = "porsche_vpc"
    route = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "porsche_igw"
      }
    ]
    tags = {
      Name = "public_rt"
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