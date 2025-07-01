region = "eu-central-1"
vpc = {
  "porsche_vpc" = {
    cidr_block = "10.10.0.0/16"
    region = "eu-central-1"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "porsche_vpc"
    }

    
  }
}