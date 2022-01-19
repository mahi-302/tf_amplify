provider "aws" {
  region = "us-east-2"
}

data "aws_ssm_parameter" "foo" {
  name = "/github/access_token"
}

resource "aws_amplify_app" "example" {
  name       = "example"
  repository = "https://github.com/mahi-302/tf_amplify.git"
  access_token = data.aws_ssm_parameter.foo.value

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}
