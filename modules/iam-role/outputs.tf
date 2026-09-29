output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}