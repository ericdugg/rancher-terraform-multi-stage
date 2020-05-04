terraform {
  backend "s3" {
    bucket = "oss-lab-terraform"
    key    = "lab/ED/rancher-terraform-multi-stage/provision"
    region = "ap-southeast-2"
    profile = "oss"
    role_arn  = "arn:aws:iam::085032814280:role/OSS_Terraform_no_MFA"
    dynamodb_table = "terraform_s3_statelock"
  }
}
