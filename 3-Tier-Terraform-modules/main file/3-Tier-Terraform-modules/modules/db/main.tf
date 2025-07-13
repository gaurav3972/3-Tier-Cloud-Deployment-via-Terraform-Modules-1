
resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnets
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  #name                 = "appdb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible = false
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
