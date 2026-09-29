################## Identity & Placement #########################
variable "identifier" {
  type = string
}
variable "db_name" {
  type    = string
  default = "astronomy_db"
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_security_group_ids" {
  type = list(string)
}
###############################################################

####################### Engine & Sizing #########################
variable "engine" {
  type    = string
  default = "postgres"
}
variable "engine_version" {
  type    = string
  default = "16.3"
}
variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "max_allocated_storage" {
  type    = number
  default = 50
}
variable "storage_type" {
  type    = string
  default = "gp3"
}
###############################################################

########################## Credentials ##########################
variable "username" {
  type    = string
  default = "postgres"
}
variable "password" {
  type      = string
  sensitive = true
}
variable "port" {
  type    = number
  default = 5432
}
###############################################################

################ High Availability & Protection ################
variable "multi_az" {
  type    = bool
  default = false
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "storage_encrypted" {
  type    = bool
  default = false
}
variable "skip_final_snapshot" {
  type    = bool
  default = true
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "backup_retention_period" {
  type    = number
  default = 1
}
###############################################################

############################ TAGS #############################
variable "tags" {
  type    = map(string)
  default = {}
}
###############################################################