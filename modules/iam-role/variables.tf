variable "assume_role_policy" {
  type = string
}
variable "name" {
  type = string
}
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "policy_arns" {
  type        = set(string)
  default     = []
  description = "Set of IAM policy ARNs to attach to the role"
}
variable "create_instance_profile" {
  type        = bool
  default     = false
  description = "Whether to create an IAM instance profile for EC2"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}
