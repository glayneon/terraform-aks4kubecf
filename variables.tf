// variable "region" {}
variable "owner" {}

# project name
variable "project" {}

# environment
variable "env" {
  type        = string
  description = "This variable defines the environment to be built"
}

# region
variable "region" {
  type = string
}

# region
# locals {
#     region-name = terraform.workspace == "dev" ? "Korea Central" : "Japan East"
# }

variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "sasmaks"
}

variable "k8sver" {
}

variable location {
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
//variable log_analytics_workspace_location {
//  default = local.region
//}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}