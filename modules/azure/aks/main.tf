resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = lower("${var.env}-aks-cluster")
  lifecycle {
    ignore_changes = [
      network_profile,
      windows_profile,
      identity,
      default_node_pool,
      node_resource_group
    ]
  }
  location            = var.location
  resource_group_name = var.resource_group
  node_resource_group = "${var.env}-nrg"
  dns_prefix          = var.env


  default_node_pool {
    name            = lower("system${var.env}")
    min_count       = var.master_pool_min_nodes
    max_count       = var.master_pool_max_nodes
    vm_size         = var.master_node_type
    os_disk_size_gb = var.master_os_disk_size

    orchestrator_version = data.azurerm_kubernetes_service_versions.aks-version.latest_version
    zones                = [1]
    enable_auto_scaling  = true
    vnet_subnet_id       = var.subnet_id

    node_labels = {
      "os"            = "linux"
      "app"           = "system"
      "environment"   = var.env
      "nodepool-type" = "system"
    }

    tags = merge(var.tags, {
      "os"            = "linux"
      "nodepool-type" = "system"
    })
  }

  identity {
    type = "SystemAssigned"
  }


  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = "standard"
  }

  private_cluster_enabled = var.private_cluster_enabled
  tags                    = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "workerpool" {
  name = lower("worker${var.env}")
  lifecycle {
    ignore_changes = [
      vm_size,
      kubernetes_cluster_id,
      node_count
    ]
  }
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
  min_count             = var.worker_pool_min_nodes
  max_count             = var.worker_pool_max_nodes
  vm_size               = var.worker_node_type
  os_disk_size_gb       = var.worker_os_disk_size
  vnet_subnet_id        = var.subnet_id
  zones                 = [1]
  enable_auto_scaling   = true
  node_labels = {
    "os"            = "linux"
    "app"           = "worker"
    "environment"   = var.env
    "nodepool-type" = "worker"
  }

  tags = merge(var.tags, {
    "os"            = "linux"
    "nodepool-type" = "worker"
  })
  depends_on = [
    azurerm_kubernetes_cluster.aks-cluster
  ]
}

