resource "tls_private_key" "private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "instance_key_pair" {
    key_name = "bastion-key"
    public_key = tls_private_key.private_key.public_key_openssh
    depends_on = [ tls_private_key.private_key ]
}

# resource "local_file" "save_key_instance" {
#     content = tls_private_key.private_key.private_key_pem
#     filename = "bastion-key.pem"
# }

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.settings.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_ids]

  associate_public_ip_address = true
  key_name = aws_key_pair.instance_key_pair.key_name

  tags = var.settings.tags
}
