output "ip" {
    value = aws_eip.nat_ip.address
  
}
output "nat" {
    value = aws_nat_gateway.nat.id
  
}
output "nat_ip" {
    value = aws_nat_gateway.nat.public_ip
  
}