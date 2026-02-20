resource "aws_db_subnet_group" "this" {
  name       = "myapp-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "myapp-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier        = "myapp-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  skip_final_snapshot = true
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.sg_ids
}
