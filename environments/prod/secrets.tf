######################## POSTGRES ###############################
resource "random_password" "postgres_rp" {
  length  = 16
  special = false
}
resource "aws_secretsmanager_secret" "postgres_secret" {
  name = "prod/rds/postgres/credentials"
}
resource "aws_secretsmanager_secret_version" "postgres_secret_version" {
  secret_id     = aws_secretsmanager_secret.postgres_secret.id
  secret_string = random_password.postgres_rp.result
}
###############################################################

############################# REDIS #############################
resource "random_password" "redis_rp" {
  length  = 16
  special = false
}
resource "aws_secretsmanager_secret" "redis_secret" {
  name = "prod/elasticache/redis/auth_token"
}
resource "aws_secretsmanager_secret_version" "redis_secret_version" {
  secret_id     = aws_secretsmanager_secret.redis_secret.id
  secret_string = random_password.redis_rp.result
}
###############################################################