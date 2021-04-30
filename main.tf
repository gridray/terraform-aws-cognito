locals {

  admin_create_user_config = var.admin_create_user_config == null ? null : {
    allow_admin_create_user_only = lookup(var.admin_create_user_config, "allow_admin_create_user_only", true)
    email = {
      message = lookup(var.admin_create_user_config.email != null ? var.admin_create_user_config.email : {}, "message", "{username}, your verification code is `{####}`")
      subject = lookup(var.admin_create_user_config.email != null ? var.admin_create_user_config.email : {}, "subject", "Your verification code")
    }
    sms = lookup(var.admin_create_user_config, "sms", "Your username is {username} and temporary password is `{####}`")
  }

  software_token_mfa_configuration_enabled = var.sms_configuration == null && var.mfa_configuration == "OFF" ? [] : [
  var.software_token_mfa_configuration_enabled]
}

/*
  Create Cognito user pool
*/
resource "aws_cognito_user_pool" "default" {
  count = module.this.enabled ? 1 : 0

  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  name                       = module.this.name
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message

  username_configuration {
    case_sensitive = var.username_case_sensitive
  }

  # admin_create_user_config
  dynamic "admin_create_user_config" {
    for_each = local.admin_create_user_config == null ? [] : [
    local.admin_create_user_config]
    content {
      allow_admin_create_user_only = admin_create_user_config.value.allow_admin_create_user_only
      invite_message_template {
        email_message = admin_create_user_config.value.email.message
        email_subject = admin_create_user_config.value.email.subject
        sms_message   = admin_create_user_config.value.sms
      }
    }
  }

  # device_configuration
  dynamic "device_configuration" {
    for_each = var.device_configuration == null ? [] : [
    var.device_configuration]
    content {
      challenge_required_on_new_device      = lookup(device_configuration.value, "challenge_required_on_new_device", false)
      device_only_remembered_on_user_prompt = lookup(device_configuration.value, "device_only_remembered_on_user_prompt", false)
    }
  }

  # email_configuration
  dynamic "email_configuration" {
    for_each = var.email_configuration == null ? [] : [
    var.email_configuration]
    content {
      reply_to_email_address = lookup(email_configuration.value, "reply_to_email_address", "")
      source_arn             = lookup(email_configuration.value, "source_arn", "")
      email_sending_account  = lookup(email_configuration.value, "email_sending_account", "COGNITO_DEFAULT")
      from_email_address     = lookup(email_configuration.value, "from_email_address", null)
    }
  }

  # lambda_config
  dynamic "lambda_config" {
    for_each = var.lambda_config == null ? [] : [
    var.lambda_config]
    content {
      create_auth_challenge          = lookup(lambda_config.value, "create_auth_challenge")
      custom_message                 = lookup(lambda_config.value, "custom_message")
      define_auth_challenge          = lookup(lambda_config.value, "define_auth_challenge")
      post_authentication            = lookup(lambda_config.value, "post_authentication")
      post_confirmation              = lookup(lambda_config.value, "post_confirmation")
      pre_authentication             = lookup(lambda_config.value, "pre_authentication")
      pre_sign_up                    = lookup(lambda_config.value, "pre_sign_up")
      pre_token_generation           = lookup(lambda_config.value, "pre_token_generation")
      user_migration                 = lookup(lambda_config.value, "user_migration")
      verify_auth_challenge_response = lookup(lambda_config.value, "verify_auth_challenge_response")
    }
  }

  # sms_configuration
  dynamic "sms_configuration" {
    for_each = var.sms_configuration == null ? [] : [
    var.sms_configuration]
    content {
      external_id    = lookup(sms_configuration.value, "external_id", "")
      sns_caller_arn = lookup(sms_configuration.value, "sns_caller_arn", "")
    }
  }

  # software_token_mfa_configuration
  dynamic "software_token_mfa_configuration" {
    for_each = local.software_token_mfa_configuration_enabled
    content {
      enabled = software_token_mfa_configuration.value
    }
  }

  # password_policy
  password_policy {
    minimum_length                   = var.password_policy_minimum_length
    require_lowercase                = var.password_policy_require_lowercase
    require_numbers                  = var.password_policy_require_numbers
    require_symbols                  = var.password_policy_require_symbols
    require_uppercase                = var.password_policy_require_uppercase
    temporary_password_validity_days = var.password_policy_temporary_password_validity_days
  }

  # schema
  dynamic "schema" {
    for_each = var.schemas == null ? {} : var.schemas
    content {
      name                     = schema.key
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = schema.value.developer_only_attribute
      mutable                  = schema.value.mutable
      required                 = schema.value.required

      dynamic "string_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "String" ? [
        schema.value.string_attribute_constraints] : []
        content {
          min_length = lookup(string_attribute_constraints.value, "min_length", 0)
          max_length = lookup(string_attribute_constraints.value, "max_length", 0)
        }
      }

      dynamic "number_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "Number" ? [
        schema.value.number_attribute_constraints] : []
        content {
          min_value = lookup(number_attribute_constraints.value, "min_value", 0)
          max_value = lookup(number_attribute_constraints.value, "max_value", 0)
        }
      }
    }
  }

  user_pool_add_ons {
    advanced_security_mode = var.user_pool_add_ons_advanced_security_mode
  }

  # verification_message_template_by_link
  verification_message_template {
    default_email_option  = lookup(var.verification_message_template, "default_email_option")
    email_message_by_link = lookup(var.verification_message_template, "email_message_by_link")
    email_subject_by_link = lookup(var.verification_message_template, "email_subject_by_link")
    email_message         = lookup(var.verification_message_template, "email_message")
    email_subject         = lookup(var.verification_message_template, "email_subject")
    sms_message           = lookup(var.verification_message_template, "sms_message")
  }

  # account_recovery_setting
  dynamic "account_recovery_setting" {
    for_each = length(var.recovery_mechanisms) == 0 ? [] : [
    1]
    content {
      # recovery_mechanism
      dynamic "recovery_mechanism" {
        for_each = var.recovery_mechanisms
        content {
          name     = recovery_mechanism.key
          priority = recovery_mechanism.value
        }
      }
    }
  }

  tags = module.this.tags
}


/*
  User pool Domain
*/

resource "aws_cognito_user_pool_domain" "domain" {
  count           = !module.this.enabled || var.domain == null || var.domain == "" ? 0 : 1
  domain          = var.domain
  certificate_arn = var.domain_certificate_arn
  user_pool_id    = aws_cognito_user_pool.default[0].id
}


/*
  Resource Server
*/

resource "aws_cognito_resource_server" "resource" {
  for_each   = module.this.enabled ? var.resource_servers : {}
  name       = each.key
  identifier = lookup(each.value, "identifier")

  #scope
  dynamic "scope" {
    for_each = lookup(each.value, "scopes")
    content {
      scope_name        = scope.key
      scope_description = scope.value
    }
  }

  user_pool_id = aws_cognito_user_pool.default[0].id
}

resource "aws_cognito_identity_provider" "default" {
  for_each = module.this.enabled? var.identity_providers: {}

  user_pool_id  = aws_cognito_user_pool.default[0].id

  provider_name = each.key
  provider_type = each.value.provider_type
  provider_details = each.value.provider_details
  attribute_mapping = each.value.attribute_mapping
  idp_identifiers = each.value.idp_identifiers
}

/*
  User Pool Client config
*/
resource "aws_cognito_user_pool_client" "client" {
  for_each                             = module.this.enabled ? var.clients : {}
  name                                 = each.key
  allowed_oauth_flows                  = lookup(each.value, "allowed_oauth_flows", null)
  allowed_oauth_flows_user_pool_client = lookup(each.value, "allowed_oauth_flows_user_pool_client", true)
  allowed_oauth_scopes                 = lookup(each.value, "allowed_oauth_scopes", [])
  callback_urls                        = lookup(each.value, "callback_urls", [])
  default_redirect_uri                 = lookup(each.value, "default_redirect_uri", "")
  explicit_auth_flows                  = lookup(each.value, "explicit_auth_flows", [])
  generate_secret                      = lookup(each.value, "generate_secret", false)
  logout_urls                          = lookup(each.value, "logout_urls", [])
  read_attributes                      = lookup(each.value, "read_attributes", [])
  access_token_validity                = lookup(each.value, "access_token_validity", 60)
  id_token_validity                    = lookup(each.value, "id_token_validity", 60)
  refresh_token_validity               = lookup(each.value, "refresh_token_validity", 30)
  supported_identity_providers         = lookup(each.value, "supported_identity_providers", [])
  prevent_user_existence_errors        = lookup(each.value, "prevent_user_existence_errors", "")
  write_attributes                     = lookup(each.value, "write_attributes", [])
  user_pool_id                         = aws_cognito_user_pool.default[0].id

  # token_validity_units
  dynamic "token_validity_units" {
    for_each = each.value.token_validity_units == null ? [] : [
    each.value.token_validity_units]
    content {
      access_token  = token_validity_units.value.access_token
      id_token      = token_validity_units.value.id_token
      refresh_token = token_validity_units.value.refresh_token
    }
  }

  depends_on = [
    aws_cognito_identity_provider.default,
    aws_cognito_resource_server.resource
  ]
}

/*
  User Pool Client UI Customization
*/
resource "aws_cognito_user_pool_ui_customization" "all-clients" {
  count = module.this.enabled && var.ui != null ? 1 : 0

  css        = var.ui.css
  image_file = var.ui.image_file != null ? filebase64(var.ui.image_file) : null

  user_pool_id = aws_cognito_user_pool.default[0].id
}

resource "aws_cognito_user_pool_ui_customization" "client" {
  for_each = module.this.enabled ? { for name, c in var.clients : name => c.ui if c.ui != null } : {}

  client_id  = aws_cognito_user_pool_client.client[each.key].id
  css        = each.value.css
  image_file = each.value.image_file != null ? filebase64(each.value.image_file) : null

  user_pool_id = aws_cognito_user_pool.default[0].id
}

/*
  User Pool Groups
*/
resource "aws_cognito_user_group" "user_groups" {
  for_each     = var.user_groups
  name         = each.key
  description  = lookup(each.value, "description")
  precedence   = lookup(each.value, "precedence")
  role_arn     = lookup(each.value, "role_arn")
  user_pool_id = aws_cognito_user_pool.default[0].id
}
