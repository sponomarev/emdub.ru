variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "emdub"
}

variable "hostname" {
  type    = string
  default = "emdub.ru"
}

locals {
  tags = {
    Project = var.project
  }
}
