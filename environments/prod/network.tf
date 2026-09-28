module "prod_vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = "10.20.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  compute_subnet_cidrs = ["10.20.10.0/24", "10.20.20.0/24"]
  data_subnet_cidrs    = ["10.20.30.0/24", "10.20.40.0/24"]
  environment          = "prod"
  project_name         = var.project_name
}