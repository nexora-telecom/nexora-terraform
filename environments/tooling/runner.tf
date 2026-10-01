### AWS SECURITY GROUP FOR RUNNER ###
resource "aws_security_group" "runner_sg" {
  name        = "tooling-public-sg"
  description = "AWS Security Group for Tooling Public Subnets"
  vpc_id      = aws_vpc.tooling_vpc.id

  tags = {
    Name = "${var.project_name}-tooling-public-sg"
  }
}

# OUTBOUND RULE #
resource "aws_vpc_security_group_egress_rule" "runner_all_outbound" {
  security_group_id = aws_security_group.runner_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

### AWS IAM ROLE FOR RUNNER ###
resource "aws_iam_role" "runner_role" {
  name = "${var.project_name}-runner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-runner-role"
  }
}


### ATTACHING SSM MANAGEMENT POLICY TO THE RUNNER ROLE ###
resource "aws_iam_role_policy_attachment" "runner_ssm_policy_attach" {
  role       = aws_iam_role.runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


### DECLARING ASSUME ROLE POLICIES FOR TOOLING AND PROD ACCOUNTS ###
resource "aws_iam_role_policy" "runner_assume_role_policy" {
  name = "${var.project_name}-runner-assume-role-policy"
  role = aws_iam_role.runner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = ["arn:aws:iam::729147110687:role/TerraformExecutionRole-Tooling", "arn:aws:iam::708379561766:role/TerraformExecutionRole-Prod"]
      },
    ]
  })
}

### AWS IAM INSTANCE PROFILE FOR RUNNER EC2 ###
resource "aws_iam_instance_profile" "runner_iam_instance_profile" {
  name = "${var.project_name}-runner-iam-instance-profile"
  role = aws_iam_role.runner_role.name
}


### QUERY LATEST AMI FOR UBUNTU SERVER 24.04 ###
data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

### RUNNER EC2 INSTANCE ###
resource "aws_instance" "runner-ec2" {
  ami                         = data.aws_ami.ubuntu-ami.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.tooling_public_subnet[0].id
  availability_zone           = var.availability_zones[0]
  iam_instance_profile        = aws_iam_instance_profile.runner_iam_instance_profile.id
  vpc_security_group_ids      = [aws_security_group.runner_sg.id]
  associate_public_ip_address = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    ignore_changes = [ami]
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 40
    volume_type           = "gp3"
  }
  tags = {
    Name = "${var.project_name}-runner-ec2"
  }
}