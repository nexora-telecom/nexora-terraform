variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "nexora-telecom"
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}