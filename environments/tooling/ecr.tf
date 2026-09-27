module "ecr_nexora_demo_service" {
  source           = "../../modules/ecr-repo"
  repository_name  = "nexora/demo-service"
  trusted_accounts = ["arn:aws:iam::708379561766:root"]
}