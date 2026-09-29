################## AWS DB SUBNET GROUP #########################
resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.identifier}-subnet-group" })
}
###############################################################

################## AWS DB PARAMETER GROUP #########################
resource "aws_db_parameter_group" "this" {
  name   = "${var.identifier}-param-group"
  family = "postgres16"
  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }
  tags = var.tags
}
###############################################################

################## AWS DB INSTANCE #########################
resource "aws_db_instance" "this" {
  identifier             = var.identifier
  db_name                = var.db_name
  vpc_security_group_ids = var.vpc_security_group_ids
  ###-------------------------------------------------------###
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  ###-------------------------------------------------------###
  username = var.username
  password = var.password
  port     = var.port
  ###--------------------------------------------------------###
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = var.storage_encrypted
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  ###--------------------------------------------------------###
  db_subnet_group_name = aws_db_subnet_group.this.name
  parameter_group_name = aws_db_parameter_group.this.name
  tags                 = merge(var.tags, { Name = var.identifier })
}
###############################################################
