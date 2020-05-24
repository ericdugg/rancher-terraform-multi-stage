terraform {
  backend "s3" {
    bucket = var.aws_s3_bucket
    key    = var.aws_s3_bucket_key
    region = var.aws_region
    profile = var.aws_profile
    role_arn  = var.aws_role_arn
    dynamodb_table = var.aws_dynamodb_table
  }
}
