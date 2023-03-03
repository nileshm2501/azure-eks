
# Get Kubernetes latest version
data "azurerm_kubernetes_service_versions" "aks-version" {
  location        = var.location
  include_preview = false
}
