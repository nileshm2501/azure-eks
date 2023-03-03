data "azurerm_subnet" "aks-subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
}


locals {
  common_tags = {
    "environment" = var.env
    "type"        = "aks"
    "tf_enabled"  = "true"
    "env"         = var.env
  }
}


module "aks-cluster" {
  source                = "../../../../modules/azure/aks/"
  count                 = 1
  env                   = var.env
  location              = var.location
  resource_group        = var.resource_group
  master_pool_min_nodes = var.master_pool_min_nodes
  master_pool_max_nodes = var.master_pool_max_nodes
  master_node_type      = var.master_node_type
  master_os_disk_size   = var.master_os_disk_size

  worker_pool_min_nodes = var.worker_pool_min_nodes
  worker_pool_max_nodes = var.worker_pool_max_nodes
  worker_node_type      = var.worker_node_type
  worker_os_disk_size   = var.worker_os_disk_size

  subnet_id = data.azurerm_subnet.aks-subnet.id

  install_cert_manager = true
  tags                 = merge(local.common_tags, )
}