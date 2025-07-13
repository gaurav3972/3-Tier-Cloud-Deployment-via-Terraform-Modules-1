
resource "aws_instance" "web" {
  count = 2
  instance_type = var.instance_type
  ami = var.ami_id
  subnet_id = element(var.public_subnets, count.index)
  vpc_security_group_ids = [var.security_group_id]
  tags = { Name = "web-${count.index+1}" }
}

output "instance_ids" {
  value = aws_instance.web[*].id
}
