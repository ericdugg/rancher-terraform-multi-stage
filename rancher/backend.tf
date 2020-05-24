terraform {
  backend "s3" {
    bucket = "<Bucket for state>"
    key    = "<Bucket key for state>"
    region = "<AWS region>"
    profile = "<AWS main profile>"
    role_arn  = "<Role for terraform>"
    dynamodb_table = "<Dynamo DB table for state>"
  }
}
