output "id" {
  description = "The id of the user pool"
  value       = module.this.enabled ? aws_cognito_user_pool.default[0].id : null
}

output "arn" {
  description = "The ARN of the user pool"
  value       = module.this.enabled ? aws_cognito_user_pool.default[0].arn : null
}

output "endpoint" {
  description = "The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = module.this.enabled ? aws_cognito_user_pool.default[0].endpoint : null
}

output "creation_date" {
  description = "The date the user pool was created"
  value       = module.this.enabled ? aws_cognito_user_pool.default[0].creation_date : null
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = module.this.enabled ? aws_cognito_user_pool.default[0].last_modified_date : null
}

#
# aws_cognito_user_pool_domain
#

output "domain_aws_account_id" {
  description = "The AWS account ID for the user pool owner"
  value       = module.this.enabled ? join("", aws_cognito_user_pool_domain.domain.*.aws_account_id) : null
}

output "domain_cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = module.this.enabled ? join("", aws_cognito_user_pool_domain.domain.*.cloudfront_distribution_arn) : null
}

output "domain_s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored"
  value       = module.this.enabled ? join("", aws_cognito_user_pool_domain.domain.*.s3_bucket) : null
}

output "domain_app_version" {
  description = "The app version"
  value       = module.this.enabled ? join("", aws_cognito_user_pool_domain.domain.*.version) : null
}

#
# aws_cognito_user_pool_client
#
output "client_ids" {
  description = "The ids of the user pool clients"
  value       = [for client in aws_cognito_user_pool_client.client : client.id]
}

output "client_ids_map" {
  description = "The client name to ids map"
  value       = { for client in aws_cognito_user_pool_client.client : client.name => client.id }
}

output "client_secrets_map" {
  description = "The client name to ids map"
  value       = { for client in aws_cognito_user_pool_client.client : client.name => client.client_secret }
  sensitive   = true
}

#
# aws_cognito_resource_servers
#
output "resource_servers_scope_identifiers" {
  description = " A list of all scopes configured in the format identifier/scope_name"
  value       = { for r in aws_cognito_resource_server.resource : r.name => r.scope_identifiers }
}