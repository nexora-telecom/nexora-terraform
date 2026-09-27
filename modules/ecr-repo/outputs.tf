output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "The URL of the repository (used by Docker CLI and Helm values to push/pull)"
}

output "repository_arn" {
  value       = aws_ecr_repository.this.arn
  description = "The ARN of the repository"
}