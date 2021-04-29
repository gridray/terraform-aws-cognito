output "id" {
  description = "The id of the user pool"
  value       = module.aws_cognito_user_pool_simple_example.id
}

output "arn" {
  description = "The ARN of the user pool"
  value       = module.aws_cognito_user_pool_simple_example.arn
}

output "endpoint" {
  description = "The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = module.aws_cognito_user_pool_simple_example.endpoint
}

output "creation_date" {
  description = "The date the user pool was created"
  value       = module.aws_cognito_user_pool_simple_example.creation_date
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = module.aws_cognito_user_pool_simple_example.last_modified_date
}

#
# aws_cognito_user_pool_domain
#

output "domain_aws_account_id" {
  description = "The AWS account ID for the user pool owner"
  value       = module.aws_cognito_user_pool_simple_example.domain_aws_account_id
}

output "domain_cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = module.aws_cognito_user_pool_simple_example.domain_cloudfront_distribution_arn
}

output "domain_s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored"
  value       = module.aws_cognito_user_pool_simple_example.domain_s3_bucket
}

output "domain_app_version" {
  description = "The app version"
  value       = module.aws_cognito_user_pool_simple_example.domain_app_version
}

#
# aws_cognito_user_pool_client
#
output "client_ids" {
  description = "The ids of the user pool clients"
  value       = module.aws_cognito_user_pool_simple_example.client_ids
}

output "client_ids_map" {
  description = "The client name to ids map"
  value       = module.aws_cognito_user_pool_simple_example.client_ids_map
}

output "client_secrets_map" {
  description = "The client name to ids map"
  value       = module.aws_cognito_user_pool_simple_example.client_secrets_map
  sensitive   = true
}

#
# aws_cognito_resource_servers
#
output "resource_servers_scope_identifiers" {
  description = " A list of all scopes configured in the format identifier/scope_name"
  value       = module.aws_cognito_user_pool_simple_example.resource_servers_scope_identifiers
}