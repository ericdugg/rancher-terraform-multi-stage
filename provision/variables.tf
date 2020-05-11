variable aws_profile {
  description = "The AWS profile name set in the credentials file"
}

variable aws_region {
  description = "The AWS region"
}

variable aws_role_arn {
  description ="The ARN of the role to assume"
}

variable "ansible_vault_password" {
  type        = string
  description = "Password for ansible vault"
}
