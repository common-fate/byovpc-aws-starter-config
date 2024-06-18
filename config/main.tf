terraform {
  required_providers {
    commonfate = {
      source  = "common-fate/commonfate"
      version = "2.13.1"
    }
  }
}
provider "commonfate" {
  # To deploy the stack you must export CF_OIDC_CLIENT_SECRET=<Your Client Secret>
  api_url            = <Replace with the same value as your app_url (e.g. "http://commonfate.example.com")>
  oidc_client_id     = <Replace with terraform_client_id from deployment/main.tf's terraform output(e.g "349dfdfkljwerpoizxckf3fds345xcvv")>
  oidc_issuer        = <Replace with auth_issuer from deployment/main.tf's terraform output(e.g "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_jieDxjtS")>
}

resource "commonfate_aws_idc_integration" "main" {
  name              = "AWS"
  reader_role_arn   = <The Reader Role ARN from aws-integration/main.tf's terraform output (e.g. "arn:aws:iam::123456789:role/common-fate-prod-idc-reader-role")>
  identity_store_id = <Your AWS SSO Instance Identity Store ID (e.g. d-123456abcd)>
  sso_instance_arn  = <Your AWS account's sso instance arn (e.g. "arn:aws:sso:::instance/ssoins-34567890vfftygfh")>
  sso_region        =  <Your AWS SSO Instance region (e.g. us-east-1)>
}

resource "commonfate_webhook_provisioner" "aws" {
  url = "http://common-fate-prod-builtin-provisioner.common-fate-prod-builtin.internal:9999"
  capabilities = [
    {
      target_type = "AWS::Account"
      role_type   = "AWS::IDC::PermissionSet"
      belonging_to = {
        type = "AWS::Organization"
        id   = <Your AWS Organization ID>
      }
    },
  ]
}
