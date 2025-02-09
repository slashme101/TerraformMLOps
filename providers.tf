terraform {
  backend "azurerm" {
    resource_group_name = "mlops-state-rg"
    storage_account_name = "mlopsstatestorage"
    container_name = "terraform-state"
    key = "mlops.tfstate"
  }
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
