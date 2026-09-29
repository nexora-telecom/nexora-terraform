module "postgres_security_group" {
  source      = "../../modules/security-group"
  name        = "${var.project_name}-prod-postgres-sg"
  description = "Security group for POSTGRES allowing TCP port 5432 from the VPC CIDR (10.20.0.0/16)"
  vpc_id      = module.prod_vpc.vpc_id
  ingress_rules = {
    tcp_5432_from_vpc = {
      cidr_ipv4   = "10.20.0.0/16"
      from_port   = 5432
      to_port     = 5432
      ip_protocol = "tcp"
    }
  }
  egress_rules = {
    allow_all_traffic_out = {
      cidr_ipv4   = "10.20.0.0/16"
      ip_protocol = "-1"
    }
  }
}

module "redis_security_group" {
  source      = "../../modules/security-group"
  name        = "${var.project_name}-prod-redis-sg"
  description = "Security group for REDIS allowing TCP port 6379 from the VPC CIDR (10.20.0.0/16)"
  vpc_id      = module.prod_vpc.vpc_id
  ingress_rules = {
    tcp_6379_from_vpc = {
      cidr_ipv4   = "10.20.0.0/16"
      from_port   = 6379
      to_port     = 6379
      ip_protocol = "tcp"
    }
  }
  egress_rules = {
    allow_all_traffic_out = {
      cidr_ipv4   = "10.20.0.0/16"
      ip_protocol = "-1"
    }
  }
}


module "prod_postgres" {
  source                 = "../../modules/rds-postgres"
  identifier             = "nexora-prod-postgres"
  subnet_ids             = module.prod_vpc.data_subnet_ids
  vpc_security_group_ids = [module.postgres_security_group.security_group_id]
  password               = random_password.postgres_rp.result
}

module "prod_redis" {
  source                 = "../../modules/elasticache-redis"
  identifier             = "nexora-prod-redis"
  subnet_ids             = module.prod_vpc.data_subnet_ids
  vpc_security_group_ids = [module.redis_security_group.security_group_id]
  auth_token             = random_password.redis_rp.result
}