module "nexora-prod-k8s-node-role" {
  source      = "../../modules/iam-role"
  name        = "nexora-prod-k8s-node-role"
  description = "IAM role for nexora-prod-k8s-node"
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
  policy_arns             = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
  tags                    = { Environment = "prod", Project = var.project_name }
}

module "nexora-prod-alb-sg" {
  source      = "../../modules/security-group"
  name        = "nexora-prod-alb-sg"
  description = "Security Group for nexora-prod-alb-sg"
  vpc_id      = module.prod_vpc.vpc_id
  tags        = { Environment = "prod", Project = var.project_name }
  ingress_rules = {
    Allow_TCP_80_from_internet = {
      description = "Allow TCP port 80 from internet"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    },
    Allow_TCP_443_from_internet = {
      description = "Allow TCP port 443 from internet"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    }
  }
}

module "nexora-k8-node-sg" {
  source      = "../../modules/security-group"
  name        = "nexora-prod-k8-node-sg"
  description = "Security Group for nexora-prod-k8-nod"
  vpc_id      = module.prod_vpc.vpc_id
  tags        = { Environment = "prod", Project = var.project_name }
  ingress_rules = {
    Allow_ALB_Traffic_TCP_30080 = {
      description                  = "Allow ALB Traffic TCP port 80 from internet"
      referenced_security_group_id = module.nexora-prod-alb-sg.security_group_id
      from_port                    = 30080
      to_port                      = 30080
      ip_protocol                  = "tcp"
    }
  }
  egress_rules = {
    Allow_OutBound = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }

  }
}

resource "aws_vpc_security_group_ingress_rule" "node_self_rule" {
  description                  = "Allow Nodes to talk to Nodes (VXLAN)"
  security_group_id            = module.nexora-k8-node-sg.security_group_id
  referenced_security_group_id = module.nexora-k8-node-sg.security_group_id
  ip_protocol                  = "-1"

}


### QUERY LATEST AMI FOR UBUNTU SERVER 22.04 ###
data "aws_ami" "ubuntu_22_04_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "k8s-master" {
  source                 = "../../modules/ec2-instance"
  name                   = "k8-master-node"
  ami                    = data.aws_ami.ubuntu_22_04_ami.id
  instance_type          = "t3.small"
  subnet_id              = module.prod_vpc.compute_subnet_ids[0]
  vpc_security_group_ids = [module.nexora-k8-node-sg.security_group_id]
  iam_instance_profile   = module.nexora-prod-k8s-node-role.instance_profile_name
}

module "k8s-worker-01" {
  source                 = "../../modules/ec2-instance"
  name                   = "k8-worker-node-01"
  ami                    = data.aws_ami.ubuntu_22_04_ami.id
  instance_type          = "t3.small"
  subnet_id              = module.prod_vpc.compute_subnet_ids[0]
  vpc_security_group_ids = [module.nexora-k8-node-sg.security_group_id]
  iam_instance_profile   = module.nexora-prod-k8s-node-role.instance_profile_name
}

module "k8s-worker-02" {
  source                 = "../../modules/ec2-instance"
  name                   = "k8-worker-node-02"
  ami                    = data.aws_ami.ubuntu_22_04_ami.id
  instance_type          = "t3.small"
  subnet_id              = module.prod_vpc.compute_subnet_ids[1]
  vpc_security_group_ids = [module.nexora-k8-node-sg.security_group_id]
  iam_instance_profile   = module.nexora-prod-k8s-node-role.instance_profile_name
}

resource "aws_lb" "prod_alb" {
  name                       = "nexora-prod-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [module.nexora-prod-alb-sg.security_group_id]
  subnets                    = module.prod_vpc.public_subnet_ids
  enable_deletion_protection = false

  tags = { Environment = "production", Project = var.project_name }
}

resource "aws_lb_target_group" "prod_tg" {
  name     = "nexora-prod-k8s-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = module.prod_vpc.vpc_id

  health_check {
    enabled             = true
    path                = "/healthz"
    port                = "30080"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_listener" "prod_lb_listener_http" {
  load_balancer_arn = aws_lb.prod_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "worker-01" {
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = module.k8s-worker-01.instance_id
  port             = 30080
}

resource "aws_lb_target_group_attachment" "worker-02" {
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = module.k8s-worker-02.instance_id
  port             = 30080
}
