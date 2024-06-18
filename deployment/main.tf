module "common-fate-deployment" {
  source  = "common-fate/common-fate-deployment/aws"
  version = "1.42.3"

  aws_region = "us-east-1 <replace this>"

  licence_key_ps_arn  = "<ARN of the licence key>"
  app_certificate_arn = "<ARN of the certificate>"

  app_url = "https://commonfate.example.com <replace this>"

  assume_role_external_id = <A random string which is used in aws-integration/main.tf when assuming cross-account AWS roles for auditing and provisioning>

  # Add after inital deployment is set up and you have aws-integration/main.tf's output
  # provisioner_aws_idc_config = {
  #   idc_instance_arn      = "<Your Identity Center Instance ARN>"
  #   idc_region            = "<Your Identity Center Region>"
  #   role_arn              = <The Provision Role ARN from aws-integration/main.tf's terraform output (e.g. "arn:aws:iam::123456789:role/common-fate-prod-idc-provisioner-role")>
  #   idc_identity_store_id = "<Your Identity Store ID>"
  # }
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
