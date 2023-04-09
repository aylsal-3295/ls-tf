variable "lightspin_account_id" {
  default = "857851802442"
}

variable "region" {
  default = "us-east-1"
}

variable "external_id" {
  default = "e2017bba-2139-403e-ae9f-803b02d88bcc"
}

variable "enable_ec2_scan" {
  type        = bool
  default = true
}

provider "aws" {
  region  = var.region
}

