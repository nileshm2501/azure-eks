terraform {
  backend "azurerm" {
    resource_group_name  = "stage"
    storage_account_name = "stagetf"
    container_name       = "tfstate"
    key                  = "stage.terraform.tfstate"
  }
}
