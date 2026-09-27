###THIS SECTION CREATES THE AWS ECR REPOSITORY###
resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    Name      = var.repository_name
    ManagedBy = "Terraform"
  }
}

### THIS SECTION CREATES THE AWS ECR REPOSITORY LIFECYCLE POLICY ###
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 1 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.untagged_retention_days}
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 5 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": ${var.tagged_retention_count}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

### THIS SECTION CREATES THE AWS IAM POLICY DOCUMENT ###
data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowCrossAccountPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.trusted_accounts
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

### THIS SECTION CREATES THE AWS ECR REPOSITORY POLICY ###
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this.json
}