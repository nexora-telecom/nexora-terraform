resource "aws_iam_role" "terraform_execution_role_tooling" {
  name = "TerraformExecutionRole-Tooling"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.runner_role.arn
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-TerraformExecutionRole-Tooling"
  }
}


resource "aws_iam_role_policy_attachment" "terraform_execution_role_tooling_policy_attach" {
  role       = aws_iam_role.terraform_execution_role_tooling.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
