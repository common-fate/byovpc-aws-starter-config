# This stack creates two IAM roles for Common Fate to connect to your AWS organization - a read role, used for syncing data about your accounts and IAM Identity Center users, and a provision role used for assigning users to accounts.

# Documentation on the required IAM permissions can be found here: https://docs.commonfate.io/integrations/aws#configuring-common-fate

# This stack should be deployed into either:

# a) your AWS organization root account, or

# b) an account with delegated administration permissions for your IAM Identity Center instance

module "common-fate-aws-roles" {
  source                                = "common-fate/common-fate-deployment/aws//modules/aws-idc-integration/iam-roles"
  version                               = "1.32.0"
  common_fate_aws_account_id              = <The ID of the account where Common Fate is deployed>
  assume_role_external_id                 = <A random string which must match the 'assume_role_external_id' on your Common Fate deployment Terraform module>
  permit_group_assignment               = true # Only needs to be set if you want JIT assignment for AWS groups
  permit_management_account_assignments = true # Only needs to be set if you want Common Fate to grant access to your organization root account
  permit_provision_permission_sets      = true # Only needs to be set if you are using resource based intgrations such as our AWS RDS intgration
}


output "read_role_arn" {
  description = "Common Fate Reader Role"
  value       = module.common-fate-aws-roles.read_role_arn
}

output "provision_role_arn" {
  description = "Common Fate Provision Role"
  value       = module.common-fate-aws-roles.provision_role_arn
}
