# The list of the services
locals {
  services = [
    "checkout-service",
    "cart-service",
    "payment-service",
    "currency-service",
    "product-catalog-service",
    "recommendation-service",
    "ad-service",
    "image-provider-service",
    "frontend-service",
    "chatbot-service",
    "quote-service",
    "shipping-service",
    "email-service",
    "accounting-service",
    "fraud-detection-service",
    "load-generator-service",
    "chaos-flagd-service"
  ]
}

# Central ECR repository definitions for Nexora microservices
module "nexora_ecr_service" {
  source           = "../../modules/ecr-repo"
  for_each         = toset(local.services)
  repository_name  = "nexora/${each.key}"
  trusted_accounts = ["arn:aws:iam::708379561766:root"]
}