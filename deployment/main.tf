// You can provision your VPC in the same Terraform root module as Common Fate,
// or alternatively create it separately and reference it using variables.
//
// In this example, we provision it in the same Terraform root module.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                         = "common-fate-vpc"
  cidr                         = "10.0.0.0/17"
  azs                          = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets               = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  private_subnets              = ["10.0.24.0/21", "10.0.32.0/21", "10.0.40.0/21"]
  database_subnets             = ["10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21"]
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  one_nat_gateway_per_az       = false
}


module "common-fate-deployment" {
  source  = "common-fate/common-fate-deployment/aws"
  version = "1.45.2"

  aws_region = "us-east-1 <replace this>"

  // Setting this to true deploys an internal load balancer
  // and means that your Common Fate deployment will not be
  // accessible to the public internet.
  //
  // You will need a VPN or similar networking solution
  // to access the deployment.
  use_internal_load_balancer = true

  vpc_id                     = module.vpc.vpc_id
  database_subnet_group_id   = module.vpc.database_subnet_group
  public_subnet_ids          = module.vpc.public_subnets
  private_subnet_ids         = module.vpc.private_subnets

  licence_key  = "<Common Fate licence key>"
  app_certificate_arn = "<ARN of the certificate>"

  app_url = "https://commonfate.example.com <replace this>"

  assume_role_external_id = <A random string which is used in aws-integration/main.tf when assuming cross-account AWS roles for auditing and provisioning>
}

output "outputs" {
  description = "outputs"
  value       = module.common-fate-deployment.outputs
}

output "terraform_client_secret" {
  description = "terraform client secret"
  value       = module.common-fate-deployment.terraform_client_secret

  sensitive = true
}
