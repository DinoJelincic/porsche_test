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
  "porsche_igw" = {
    vpc_id = "porsche_vpc" 
  }
}

