output "prod_execution_role_arn" {
  value = aws_iam_role.terraform_execution_role_prod.arn
}

### OUTPUTS FROM MODULE PROD-VPC ###
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

output "alb_dns_name" {
  description = "Public DNS hostname of the production Application Load Balancer"
  value       = aws_lb.prod_alb.dns_name
}

###################################### INSTANCE ID & IP ADDRESS OF EC2 INSTANCES ####################################################
### MASTER  ###
output "k8s_master_instance_id" {
  value = module.k8s-master.instance_id
}
output "k8s_master_private_ip" {
  value = module.k8s-master.private_ip
}
################

### WORKER-01 ###
output "k8s_worker_1_instance_id" {
  value = module.k8s-worker-01.instance_id
}
output "k8s_worker_1_private_ip" {
  value = module.k8s-worker-01.private_ip
}
################

### WORKER-02  ###
output "k8s_worker_2_instance_id" {
  value = module.k8s-worker-02.instance_id
}
output "k8s_worker_2_private_ip" {
  value = module.k8s-worker-02.private_ip
}
################

### EC2 NAT  ###
output "nat_instance_id" {
  value = module.nat_instance.instance_id
}
output "nat_public_ip" {
  value = module.nat_instance.public_ip
}
################################################################################################################