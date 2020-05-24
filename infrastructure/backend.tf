terraform {
  backend "s3" {
    bucket = "<bucket name>"
    key    = "<key name>"
    region = "<region>"
    profile = "<aws profile>"
    role_arn  = "<role for terraform>"
    dynamodb_table = "<table name>"
  }
}
