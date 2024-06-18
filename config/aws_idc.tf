resource "commonfate_access_workflow" "production" {
  name                      = "Production Access"
  access_duration_seconds   = 60 * 60 * 8 // maximum duration for a request
  default_duration_seconds  = 60 * 60 * 2 // the default duration for a request
  activation_expiry         = 60 * 60 * 24 // automatically close approved requests if they aren't activated within 24h
  priority                  = 1

  validation {
    has_reason = true // require a reason on all requests, or remove this to disable the requirement.
  }
}

resource "commonfate_aws_account_selector" "select_all" {
  id                  = "select_all_aws"
  name                = "Select All AWS"
  aws_organization_id = <Your AWS Organization ID>
  when                = "true"
}

resource "commonfate_aws_idc_account_availabilities" "aws" {
  workflow_id             = commonfate_access_workflow.production.id
  aws_permission_set_arn  = <The permission set ARN to grant access to>
  aws_account_selector_id = commonfate_aws_account_selector.select_all.id
  aws_identity_store_id   =  <Your AWS SSO Instance Identity Store ID (e.g. d-123456abcd)>
}
