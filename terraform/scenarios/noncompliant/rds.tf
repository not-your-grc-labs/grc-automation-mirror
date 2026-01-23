resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.dmz_subnet1.id, aws_subnet.dmz_subnet2.id]

  tags = {
    name        = "RDS Subnet Group"
    owner       = "Andrew"
    managed_by = "Terraform"
  }
}

resource "aws_rds_cluster" "my_rds_cluster" {
  cluster_identifier      = "my-rds-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.08.2"
  master_username         = var.rds_username
  master_password         = var.rds_password
  database_name           = "mydatabase"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = true
  storage_encrypted = false

  tags = {
    owner       = "Andrew"
    managed_by  = "Terraform"
    public_facing = true
    environment = "prod"
  }
}