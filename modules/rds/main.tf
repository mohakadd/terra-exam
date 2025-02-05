resource "aws_db_subnet_group" "this" {
  name        = "my-rds-subnet-group"
  description = "Subnet group for RDS"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "MyRDSSubnetGroup"
  }
}

resource "aws_db_instance" "this" {
  identifier         = "my-wordpress-db"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_subnet_group_name = aws_db_subnet_group.this.name
  username           = var.db_username
  password           = var.db_password
  db_name            = var.db_name
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az            = true
  publicly_accessible  = false

  # activer l’auto minor version upgrade
  auto_minor_version_upgrade = true

  tags = {
    Name = "MyWordpressRDS"
  }
}
