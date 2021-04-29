provider "aws" {
  region = var.region
}

module "aws_cognito_user_pool_simple_example" {

  source = "../../"

  name    = "simple_pool"
  context = module.this.context
}