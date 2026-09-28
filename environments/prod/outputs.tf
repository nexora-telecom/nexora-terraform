output "prod_execution_role_arn" {
  value = aws_iam_role.terraform_execution_role_prod.arn
}

### OUTPUTS FROM MODULE PRDO-VPC ###
output "vpc_id" {
  value = module.prod_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.prod_vpc.public_subnet_ids
}

output "compute_subnet_ids" {
  value = module.prod_vpc.compute_subnet_ids
}

output "data_subnet_ids" {
  value = module.prod_vpc.data_subnet_ids
}

output "compute_route_table_id" {
  value = module.prod_vpc.compute_route_table_id
}