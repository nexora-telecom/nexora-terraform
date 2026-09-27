variable "repository_name" {
  type        = string
  description = "Name of the ECR repository (e.g. nexora/cart-service)"
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository"
  default     = true
}

variable "untagged_retention_days" {
  type        = number
  description = "The number of days after which untagged images expire"
  default     = 1
}

variable "tagged_retention_count" {
  type        = number
  description = "The maximum number of tagged images to retain"
  default     = 5
}

variable "trusted_accounts" {
  type        = list(string)
  description = "List of AWS Account ARNs permitted to pull images cross-account"
}

