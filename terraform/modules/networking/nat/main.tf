resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = var.subnet_id

  tags = var.settings.tags
}