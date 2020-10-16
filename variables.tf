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
  default = 10
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "sasmaks"
}

variable "k8sver" {}

variable "private_subnet_mode" {}

variable "location" {}

variable "network_policy" {}

variable "mon_count" {}

// variable "log_count" {}

variable "cfnodes_count" {}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
//variable log_analytics_workspace_location {
//  default = local.region
//}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
