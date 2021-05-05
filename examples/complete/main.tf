provider "aws" {
  region = var.region
}

module "aws_cognito_user_pool_complete_example" {

  source = "../../"

  name    = "complete_pool"
  context = module.this.context


  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  sms_authentication_message = "Your username is {username} and temporary password is {####}."

  mfa_configuration                        = "OPTIONAL"
  software_token_mfa_configuration_enabled = true

  admin_create_user_config = {
    allow_admin_create_user_only = true
    email = {
      message = "Dear {username}, your verification code is {####}."
      subject = "Here, your verification code baby"
    }
    sms = "Your username is {username} and temporary password is {####}."
  }

  device_configuration = {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }

  email_configuration = {
    reply_to_email_address = "no-reply@gridray.com"
  }

  password_policy_minimum_length                   = 10
  password_policy_require_lowercase                = false
  password_policy_require_numbers                  = true
  password_policy_require_symbols                  = true
  password_policy_require_uppercase                = true
  password_policy_temporary_password_validity_days = 120

  user_pool_add_ons_advanced_security_mode = "ENFORCED"

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Dear {username}, your verification code is {####}."
    email_subject        = "Here, your verification code baby"
    sms_message          = "This is the verification message {####}."
  }

  schemas = {
    available = {
      attribute_data_type      = "Boolean"
      developer_only_attribute = false
      mutable                  = true
      required                 = false
    }
    registered = {
      attribute_data_type      = "Boolean"
      developer_only_attribute = true
      mutable                  = true
      required                 = false
    }
    email = {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      required                 = true
      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    }
    gender = {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      required                 = true

      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    }
    mynumber1 = {
      attribute_data_type      = "Number"
      developer_only_attribute = true
      mutable                  = true
      required                 = false
      number_attribute_constraints = {
        min_value = 2
        max_value = 6
      }
    }
    mynumber2 = {
      attribute_data_type      = "Number"
      developer_only_attribute = true
      mutable                  = true
      required                 = false

      number_attribute_constraints = {
        min_value = 2
        max_value = 6
      }
    }
  }

  # user_pool_domain
  domain = "gridray-test-com"


  # clients
  clients = {
    test1 = {
      allowed_oauth_flows                  = []
      allowed_oauth_flows_user_pool_client = false
      allowed_oauth_scopes                 = []
      callback_urls                        = ["https://gridray-test.com/callback"]
      default_redirect_uri                 = "https://gridray-test.com/callback"
      explicit_auth_flows                  = []
      generate_secret                      = true
      logout_urls                          = []
      read_attributes                      = ["email"]
      supported_identity_providers         = []
      write_attributes                     = []
      access_token_validity                = 1
      id_token_validity                    = 1
      refresh_token_validity               = 60
      token_validity_units = {
        access_token  = "hours"
        id_token      = "hours"
        refresh_token = "days"
      }

      ui = {
        css        = ".label-customizable {font-weight: 400;}"
        image_file = "./images/logo.png"
      }
    }
    test2 = {
      allowed_oauth_flows                  = []
      allowed_oauth_flows_user_pool_client = false
      allowed_oauth_scopes                 = []
      callback_urls                        = ["https://mydomain.com/callback"]
      default_redirect_uri                 = "https://mydomain.com/callback"
      explicit_auth_flows                  = []
      generate_secret                      = false
      logout_urls                          = []
      read_attributes                      = []
      supported_identity_providers         = []
      write_attributes                     = []
      refresh_token_validity               = 30
    }
    test3 = {
      allowed_oauth_flows                  = ["code", "implicit"]
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes                 = ["email", "openid"]
      callback_urls                        = ["https://mydomain.com/callback"]
      default_redirect_uri                 = "https://mydomain.com/callback"
      explicit_auth_flows                  = ["CUSTOM_AUTH_FLOW_ONLY", "ADMIN_NO_SRP_AUTH"]
      generate_secret                      = false
      logout_urls                          = ["https://mydomain.com/logout"]
      read_attributes                      = ["email", "phone_number"]
      supported_identity_providers         = []
      write_attributes                     = ["email", "gender", "locale", ]
      refresh_token_validity               = 30
    }
  }

  # user_group
  user_groups = {
    mygroup1 = {
      description = "My group 1"
    }
    mygroup2 = {
      description = "My group 2"
    }
  }

  # resource_servers
  resource_servers = {
    "mydomain" : {
      identifier = "https://mydomain.com"
      scopes = {
        "sample-scope-1" = "A sample Scope Description for mydomain.com"
        "sample-scope-2" = "Another sample Scope Description for mydomain.com"
      }
    }
    "weather-read" = {
      identifier = "https://weather-read-app.com"
      name       = "weather-read"
      scopes = {
        "weather.read" = "Read weather forecasts"
      }
    }
  }

  ui = {
    css        = ".label-customizable {font-weight: 400;}"
    image_file = "./images/logo.png"
  }

}