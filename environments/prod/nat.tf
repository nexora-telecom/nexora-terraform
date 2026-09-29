data "aws_ssm_parameter" "al2023_arm64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

##################### MODULE CALLING IAM ROLE CREATION ######################
module "nat_iam_role" {
  source = "../../modules/iam-role"
  name   = "${var.project_name}-prod-nat-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  create_instance_profile = true
  policy_arns             = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  tags                    = { Environment = "prod", Project = var.project_name }
}
############################################################################

################## MODULE CALLING SECURITY GROUP CREATION ##################
module "nat_security_group" {
  source      = "../../modules/security-group"
  name        = "${var.project_name}-prod-nat-sg"
  description = "Security group for NAT instance allowing compute tier egress"
  vpc_id      = module.prod_vpc.vpc_id
  ingress_rules = {
    http_from_vpc = {
      cidr_ipv4   = "10.20.0.0/16"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    }
    https_from_vpc = {
      cidr_ipv4   = "10.20.0.0/16"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    }
  }
}
############################################################################

################### MODULE CALLING EC2 INSTANCE CREATION ###################
module "nat_instance" {
  source                      = "../../modules/ec2-instance"
  name                        = "${var.project_name}-prod-nat"
  ami                         = data.aws_ssm_parameter.al2023_arm64.value
  instance_type               = "t4g.micro"
  subnet_id                   = module.prod_vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [module.nat_security_group.security_group_id]
  iam_instance_profile        = module.nat_iam_role.instance_profile_name
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = <<-EOF
#!/bin/bash
set -e

# Enable IPv4 packet forwarding in the Linux kernel
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-ip-forward.conf

# Install iptables persistence service
dnf install -y iptables-services
systemctl enable iptables
systemctl start iptables

# Discover the primary network interface (e.g. ens5)
PRIMARY_IF=$(ip -o -4 route show to default | awk '{print $5}')

# Apply NAT masquerade rule for outbound traffic leaving the primary interface
iptables -t nat -A POSTROUTING -o $PRIMARY_IF -j MASQUERADE
service iptables save
EOF
}

resource "aws_route" "this" {
  route_table_id         = module.prod_vpc.compute_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.primary_network_interface_id
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = module.prod_vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.prod_vpc.compute_route_table_id]
  tags              = { Name = "${var.project_name}-prod-s3-endpoint", Environment = "prod" }
}