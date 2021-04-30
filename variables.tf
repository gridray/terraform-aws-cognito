variable "admin_create_user_config" {
  description = "Enable admin create user configuration"
  type = object({
    allow_admin_create_user_only = bool
    email = object({
      message : string
      subject : string
    })
    sms = string
  })
  default = null
}


variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list(string)
  default     = null
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified. Possible values: email, phone_number"
  type        = list(string)
  default     = []
}

variable "clients" {
  description = "A container with the clients definitions"
  type = map(object({
    allowed_oauth_flows                  = optional(list(string))
    allowed_oauth_flows_user_pool_client = optional(bool)
    allowed_oauth_scopes                 = optional(list(string))
    callback_urls                        = optional(list(string))
    default_redirect_uri                 = optional(string)
    explicit_auth_flows                  = optional(list(string))
    generate_secret                      = optional(bool)
    logout_urls                          = optional(list(string))
    read_attributes                      = optional(list(string))
    prevent_user_existence_errors        = optional(string)
    supported_identity_providers         = optional(list(string))
    write_attributes                     = optional(list(string))
    access_token_validity                = optional(number)
    id_token_validity                    = optional(number)
    refresh_token_validity               = optional(number)
    token_validity_units = optional(object({
      access_token  = optional(string)
      id_token      = optional(string)
      refresh_token = optional(string)
    }))
    ui = optional(object({
      css        = optional(string)
      image_file = optional(string)
    }))
  }))
  default = {}
}

variable "device_configuration" {
  description = "The configuration for the user pool's device tracking"
  type = object({
    challenge_required_on_new_device      = bool
    device_only_remembered_on_user_prompt = bool
  })
  default = null
}

variable "domain" {
  description = "Cognito User Pool domain"
  type        = string
  default     = null
}

variable "domain_certificate_arn" {
  description = "The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain"
  type        = string
  default     = null
}

variable "email_configuration" {
  description = "The Email Configuration"
  type = object({
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
    email_sending_account  = optional(string)
    from_email_address     = optional(string)
  })
  default = null
}

variable "identity_providers" {
  type = map(object({
    provider_type = string
    provider_details = map(any)
    attribute_mapping = optional(map(string))
    idp_identifiers = optional(list(string))
  }))
  description = "Identity provider connected to userpool"
  default = {}
}

variable "lambda_config" {
  description = "A container for the AWS Lambda triggers associated with the user pool"
  type = object({
    create_auth_challenge          = string
    custom_message                 = string
    define_auth_challenge          = string
    post_authentication            = string
    post_confirmation              = string
    pre_authentication             = string
    pre_sign_up                    = string
    pre_token_generation           = string
    user_migration                 = string
    verify_auth_challenge_response = string
  })
  default = null
}

variable "mfa_configuration" {
  description = "Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL)"
  type        = string
  default     = "OFF"
}

variable "password_policy_minimum_length" {
  description = "The minimum length of the password policy that you have set"
  type        = number
  default     = 8
}

variable "password_policy_require_lowercase" {
  description = "Whether you have required users to use at least one lowercase letter in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_numbers" {
  description = "Whether you have required users to use at least one number in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_symbols" {
  description = "Whether you have required users to use at least one symbol in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_uppercase" {
  description = "Whether you have required users to use at least one uppercase letter in their password"
  type        = bool
  default     = true
}

variable "password_policy_temporary_password_validity_days" {
  description = "The minimum length of the password policy that you have set"
  type        = number
  default     = 7
}

variable "schemas" {
  description = "A container with the schema attributes of a user pool. Maximum of 50 attributes"
  type = map(object({
    attribute_data_type      = string
    developer_only_attribute = bool
    mutable                  = bool
    required                 = bool
    string_attribute_constraints = optional(object({
      min_length = number
      max_length = number
    }))
    number_attribute_constraints = optional(object({
      min_value = number
      max_value = number
    }))
  }))
  default = {}
}

variable "recovery_mechanisms" {
  description = "The list of Account Recovery Options"
  type        = map(number)
  default     = {}
}

variable "resource_servers" {
  description = "A container with the resource_servers definitions"
  type = map(object({
    identifier = string
    scopes     = optional(map(string))
  }))
  default = {}
}

variable "sms_authentication_message" {
  description = "A string representing the SMS authentication message"
  type        = string
  default     = null
}

variable "sms_configuration" {
  description = "The SMS Configuration"
  type = object({
    external_id    = string
    sns_caller_arn = string
  })
  default = null
}

variable "software_token_mfa_configuration_enabled" {
  description = "If true, and if mfa_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled"
  type        = bool
  default     = false
}

variable "ui" {
  description = "If UI Customization is required for all clients then object should be set "
  type = object({
    css        = optional(string)
    image_file = optional(string)
  })
  default = null
}

variable "username_case_sensitive" {
  description = "The Username Configuration. Seting `case_sesiteve` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs"
  type        = bool
  default     = false
}

variable "user_groups" {
  description = "A container with the user_groups definitions"
  type = map(object({
    description = optional(string)
    precedence  = optional(number)
    role_arn    = optional(string)
  }))
  default = {}
}

variable "user_pool_add_ons_advanced_security_mode" {
  description = "The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED`"
  type        = string
  default     = "OFF"
}

variable "verification_message_template" {
  description = "The verification message templates configuration"
  type = object({
    default_email_option  = string
    email_message_by_link = optional(string)
    email_subject_by_link = optional(string)
    email_message         = optional(string)
    email_subject         = optional(string)
    sms_message           = optional(string)
  })
  default = {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}
