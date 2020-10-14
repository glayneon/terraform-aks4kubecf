resource "random_id" "log_analytics_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "sasm-log-aks" {
  depends_on = [azurerm_resource_group.sasm-dev-aks]
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${lower(var.project)}-${lower(var.env)}-log-${random_id.log_analytics_suffix.dec}"
  location            = var.location
  resource_group_name = azurerm_resource_group.sasm-dev-aks.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "sasm-log-aks" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.sasm-log-aks.location
  resource_group_name   = azurerm_resource_group.sasm-dev-aks.name
  workspace_resource_id = azurerm_log_analytics_workspace.sasm-log-aks.id
  workspace_name        = azurerm_log_analytics_workspace.sasm-log-aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "sasm-aks01" {
  depends_on = [azurerm_resource_group.sasm-dev-aks]
  name                = "${lower(var.project)}-${lower(var.env)}-aks01"
  location            = azurerm_resource_group.sasm-dev-aks.location
  resource_group_name = azurerm_resource_group.sasm-dev-aks.name
  dns_prefix          = var.dns_prefix
  kubernetes_version = var.k8sver
  private_cluster_enabled = var.private_subnet_mode

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.sasm-log-aks.id
    }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
    // network_policy = var.network_policy
  }

  tags = {
    owner   = var.owner
    project = var.project
    env     = "${lower(var.project)}-${var.env}"
  }
}