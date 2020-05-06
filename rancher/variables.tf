variable aws_profile {
  description = "The AWS profile name set in the credentials file"
}

variable aws_region {
  description = "The AWS region"
}

variable aws_role_arn {
  description ="The ARN of the role to assume"
}

variable "rancher_password" {
  type        = string
  description = "Password to set for Rancher root user"
}

variable "rancher_current_password" {
  type        = string
  default     = null
  description = "Rancher admin user current password"
}

variable "rancher_version" {
  type        = string
  default     = "2.4.2"
  description = "Version of Rancher to install"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}
