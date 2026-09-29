variable "name" {
  type = string
}
variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "iam_instance_profile" {
  type    = string
  default = null
}
variable "associate_public_ip_address" {
  type    = bool
  default = false
}
variable "source_dest_check" {
  type    = bool
  default = true
}
variable "user_data" {
  type    = string
  default = null
}
variable "root_volume_size" {
  type    = number
  default = 20
}
variable "root_volume_type" {
  type    = string
  default = "gp3"
}
variable "tags" {
  type    = map(string)
  default = {}
}