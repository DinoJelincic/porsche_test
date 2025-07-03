resource "aws_key_pair" "ec2_key" {
  key_name   = "porsche_ec2_key"
  public_key = var.ec2_public_key
}

resource "aws_instance" "app_instance" {
  ami                    = var.ami_id
  instance_type          = var.settings.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.instance_profile

  associate_public_ip_address = false

  key_name = aws_key_pair.ec2_key.key_name


  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              EOF

  tags = var.settings.tags

  depends_on = [aws_key_pair.ec2_key]
}


