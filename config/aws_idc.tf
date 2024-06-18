resource "commonfate_access_workflow" "aws" {
  name                     = "aws"
  access_duration_seconds  = 60 * 60 * 2
  try_extend_after_seconds = 60 * 60
  priority                 = 1
}

resource "commonfate_aws_account_selector" "select_all" {
  id                  = "select_all_aws"
  name                = "Select All AWS"
  aws_organization_id = <Your AWS Organization ID>
  when                = "true"
}

resource "commonfate_aws_idc_account_availabilities" "aws" {
  workflow_id             = commonfate_access_workflow.aws.id
  aws_permission_set_arn  = <The permission set ARN to grant access to>
  aws_account_selector_id = commonfate_aws_account_selector.select_all.id
  aws_identity_store_id   =  <Your AWS SSO Instance Identity Store ID (e.g. d-123456abcd)>

}
