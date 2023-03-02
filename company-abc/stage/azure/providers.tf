provider "helm" {
  kubernetes {
    config_path = "kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "kubeconfig"
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}