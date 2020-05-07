data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "oss-lab-terraform"
    key    = "lab/ED/rancher-terraform-multi-stage/infrastructure"
    region = var.aws_region
    profile = var.aws_profile
    role_arn  = var.aws_role_arn
    dynamodb_table = "terraform_s3_statelock"
  }
}