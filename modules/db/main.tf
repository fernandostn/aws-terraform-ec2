data "aws_availability_zones" "available" {}

resource "aws_db_subnet_group" "db_subnet_g" {
  name       = "db"
  subnet_ids = [var.subnet0, var.subnet1]

  tags = {
    Name = "Terraform DB Subnet Group"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_rds_cluster" "aurora_db" {
  cluster_identifier     = "rdscluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.11.4"
  availability_zones     = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  vpc_security_group_ids = [var.sg]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_g.name
  database_name          = "immersionday"
  master_username        = var.master_username
  master_password        = random_password.password.result
  skip_final_snapshot    = true

  tags = {
    Name = "Terraform Aurora Cluster"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = var.az_count
  db_subnet_group_name = aws_db_subnet_group.db_subnet_g.name
  identifier           = "aurora-cluster-terraform-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_db.id
  instance_class       = "db.r5.large"
  engine               = aws_rds_cluster.aurora_db.engine
  engine_version       = aws_rds_cluster.aurora_db.engine_version
}

resource "aws_secretsmanager_secret" "secret_db" {
  name                           = "mysecret"
  force_overwrite_replica_secret = "true"
  recovery_window_in_days        = 0
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secret_db.id
  secret_string = <<EOF
   {
    "username": "${var.master_username}",
    "password": "${random_password.password.result}",
    "engine": "${aws_rds_cluster.aurora_db.engine}",
    "host": "${aws_rds_cluster.aurora_db.endpoint}",
    "port": "${aws_rds_cluster.aurora_db.port}",
    "dbClusterIdentifier": "${aws_rds_cluster.aurora_db.cluster_identifier}",
    "dbname": "${aws_rds_cluster.aurora_db.database_name}"
   }
EOF
}