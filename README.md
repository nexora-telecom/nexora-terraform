# Nexora Terraform (Multi-Account Cloud Infrastructure)

Enterprise Infrastructure as Code for the Nexora Telecom Platform across AWS Account 1 (Tooling) and Account 2 (Production: 708379561766).

## Directory Layout
* `terraform-bootstrap/`: Solves the backend bootstrap paradox; creates S3 state buckets and DynamoDB lock tables.
* `environments/tooling/`: Account 1 VPC (10.100.0.0/16), Self-Hosted GitHub Actions Runner, Central Amazon ECR.
* `environments/prod/`: Account 2 Multi-AZ VPC (10.20.0.0/16), Upstream K8s EC2 nodes, ALB, RDS PostgreSQL, ElastiCache Redis (TLS), MSK Kafka.
* `modules/`: Modular reusable building blocks (vpc, k8s-nodes, rds, elasticache, msk, iam).
