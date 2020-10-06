terraform {
  backend "azurerm" {
    resource_group_name  = "sasm-dev-tfstate-rg"
    storage_account_name = "sasmtfstateei5w7ocr"
    container_name       = "sasm-dev-tfstate"
    key                  = "sasm-dev-aks-tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sasm-dev-aks" {
  name = "${lower(var.project)}-${lower(var.env)}-aks"
  // location = "${terraform.workspace == default ? koreacentral : japaneast}"
  location = var.region

  lifecycle {
    prevent_destroy = false
  }
  tags = {
    owner   = var.owner
    project = var.project
    env     = "${lower(var.project)}-${var.env}"
  }
}
