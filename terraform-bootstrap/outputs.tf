output "tooling_account_id" {
  value = data.aws_caller_identity.tooling.account_id
}
output "prod_account_id" {
  value = data.aws_caller_identity.prod.account_id
}
output "tooling_state_bucket" {
  value = aws_s3_bucket.tooling_state.id
}
output "tooling_lock_table" {
  value = aws_dynamodb_table.tooling_state_dynamodb_table.name
}
output "prod_state_bucket" {
  value = aws_s3_bucket.prod_state.id
}
output "prod_lock_table" {
  value = aws_dynamodb_table.prod_state_dynamodb_table.name
}