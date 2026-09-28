output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "compute_subnet_ids" {
  value = aws_subnet.compute[*].id
}

output "data_subnet_ids" {
  value = aws_subnet.data[*].id
}

output "compute_route_table_id" {
  value = aws_route_table.compute.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}