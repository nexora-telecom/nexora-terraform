resource "aws_iam_user" "nexora_ssm_operator" {
  name = "${var.project_name}-ssm-operator"

  tags = {
    Name = "${var.project_name}-ssm-operator"
  }
}

resource "aws_iam_policy" "nexora_ssm_operator_policy" {
  name = "${var.project_name}-prod-ssm-operator-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:StartSession",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:${var.aws_region}:708379561766:instance/${module.k8s-master.instance_id}",
          "arn:aws:ec2:${var.aws_region}:708379561766:instance/${module.k8s-worker-01.instance_id}",
          "arn:aws:ec2:${var.aws_region}:708379561766:instance/${module.k8s-worker-02.instance_id}",
          "arn:aws:ec2:${var.aws_region}:708379561766:instance/${module.nat_instance.instance_id}",
          "arn:aws:ssm:${var.aws_region}::document/AWS-StartSSHSession",
          "arn:aws:ssm:${var.aws_region}::document/SSM-SessionManagerRunShell"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeInstanceProperties",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }

    ]
  })
}

resource "aws_iam_user_policy_attachment" "nexora_ssm_operator_policy_attachment" {
  user       = aws_iam_user.nexora_ssm_operator.name
  policy_arn = aws_iam_policy.nexora_ssm_operator_policy.arn
}