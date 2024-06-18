module "common-fate-deployment" {
  source  = "common-fate/common-fate-deployment/aws"
  version = "1.45.2"

  aws_region = "us-east-1 <replace this>"

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
