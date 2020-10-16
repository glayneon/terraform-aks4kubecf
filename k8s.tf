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
    name       = "systems"
    node_count = var.mon_count
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = false
    }
    kube_dashboard {
      enabled = true
    }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
    network_policy = var.network_policy
  }

  tags = {
    owner   = var.owner
    project = var.project
    env     = "${lower(var.project)}-${var.env}"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "cfnodes" {
  name                  = "cfnodes"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.sasm-aks01.id
  vm_size               = "Standard_DS2_v2"
  node_count            = var.cfnodes_count

  tags = {
    owner   = var.owner
    project = var.project
    env     = "${lower(var.project)}-${var.env}"
  }
}