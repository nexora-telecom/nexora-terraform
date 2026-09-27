output "tooling_vpc_id" {
  value = aws_vpc.tooling_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.tooling_public_subnet[*].id
}

output "runner_instance_id" {
  value = aws_instance.runner-ec2.id
}

output "runner_public_ip" {
  value = aws_instance.runner-ec2.public_ip
}

output "runner_private_ip" {
  value = aws_instance.runner-ec2.private_ip
}

output "runner_security_group_id" {
  value = aws_security_group.runner_sg.id
}