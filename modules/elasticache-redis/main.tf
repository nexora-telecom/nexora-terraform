resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.identifier}-elasticache-subnet-group"
  subnet_ids = var.subnet_ids
}
resource "aws_elasticache_parameter_group" "this" {
  name   = "${var.identifier}-elasticache-parameter-group"
  family = var.family
}

resource "aws_elasticache_replication_group" "this" {
  engine_version             = var.engine_version
  engine                     = "redis"
  node_type                  = var.node_type
  port                       = var.port
  auth_token                 = var.auth_token
  num_cache_clusters         = var.num_cache_clusters
  multi_az_enabled           = var.multi_az_enabled
  automatic_failover_enabled = var.automatic_failover_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  replication_group_id       = var.identifier
  description                = "Redis cluster for ${var.identifier}"
  security_group_ids         = var.vpc_security_group_ids
  parameter_group_name       = aws_elasticache_parameter_group.this.id
  subnet_group_name          = aws_elasticache_subnet_group.this.id
  tags                       = var.tags
}