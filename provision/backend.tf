terraform {
  backend "s3" {
    bucket = "oss-lab-terraform"
    key    = "lab/ED/rancher-terraform-multi-stage/provision"
    region = var.aws_region
    profile = var.aws_profile
    role_arn  = var.aws_role_arn
    dynamodb_table = "terraform_s3_statelock"
  }
}
