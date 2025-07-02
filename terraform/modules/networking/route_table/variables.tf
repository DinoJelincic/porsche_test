variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "gateway_id" {
  type    = string
  default = null
}

variable "nat_gateway_id" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}
