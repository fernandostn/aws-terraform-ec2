resource "aws_db_subnet_group" "db_subnet_g" {
  name       = "db"
  subnet_ids = [var.subnet0, var.subnet1]

  tags = {
    Name = "Terraform DB Subnet Group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage           = 10
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  username                    = "localadm"
  password                    = "localadm"
  parameter_group_name        = "default.mysql5.7"
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_g.name
  vpc_security_group_ids      = [var.sg]
  multi_az                    = true
  skip_final_snapshot         = true

  tags = {
    Name = "Terraform MySQL RDS DB "
  }
}