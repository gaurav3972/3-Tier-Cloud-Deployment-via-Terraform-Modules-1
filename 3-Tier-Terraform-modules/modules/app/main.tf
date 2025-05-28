resource "aws_instance" "app" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnets[count.index]
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "app-${count.index + 1}"
  }
}

output "instance_ids" {
  value = aws_instance.app[*].id
}
