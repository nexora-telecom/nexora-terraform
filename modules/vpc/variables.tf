variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "availability_zones" {
  type        = list(string)
  description = "Target Availability Zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR for Public Subnet"
}

variable "compute_subnet_cidrs" {
  type        = list(string)
  description = "CIDR for Compute Subnet CIDR"
}

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "CIDR for Data Subnet CIDR"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "project_name" {
  type        = string
  description = "nexora"
}