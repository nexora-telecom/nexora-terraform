variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type        = any
  default     = {}
  description = "Map of ingress rule objects"
}
variable "egress_rules" {
  type = any
  default = {
    all_outbound = {
      description = "Allow all outbound traffic"
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
  description = "Map of egress rule objects"
}

variable "tags" {
  type    = map(string)
  default = {}
}