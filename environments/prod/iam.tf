resource "aws_iam_role" "terraform_execution_role_prod" {
  name = "TerraformExecutionRole-Prod"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::729147110687:role/nexora-telecom-runner-role"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-TerraformExecutionRole-Prod"
  }
}


resource "aws_iam_role_policy_attachment" "terraform_execution_role_prod_policy_attach" {
  role       = aws_iam_role.terraform_execution_role_prod.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
