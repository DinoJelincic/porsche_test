output "id" {
  value = aws_subnet.subnet.id
}
output "virtual_network_id" {
  value = aws_subnet.subnet.vpc_id

}
output "cidr_block" {
  value = aws_subnet.subnet.cidr_block

}