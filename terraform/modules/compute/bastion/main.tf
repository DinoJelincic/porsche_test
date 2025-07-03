resource "aws_key_pair" "ec2_key" {
  key_name   = "bastion_ec2_key"
  public_key = file("~/.ssh/bastion_ec2_key.pub")
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.settings.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_ids]

  associate_public_ip_address = true
  key_name = aws_key_pair.ec2_key.key_name

  tags = var.settings.tags
}
