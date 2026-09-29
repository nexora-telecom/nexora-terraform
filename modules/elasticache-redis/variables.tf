variable "identifier" {
  type = string
}
variable "family" {
  type    = string
  default = "redis7"
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_security_group_ids" {
  type = list(string)
}

variable "engine_version" {
  type    = string
  default = "7.1"
}
variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "port" {
  type    = number
  default = 6379
}
variable "auth_token" {
  type      = string
  sensitive = true
}

variable "num_cache_clusters" {
  type    = number
  default = 1
}
variable "multi_az_enabled" {
  type    = bool
  default = false
}
variable "automatic_failover_enabled" {
  type    = bool
  default = false
}
variable "at_rest_encryption_enabled" {
  type    = bool
  default = true
}
variable "transit_encryption_enabled" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
