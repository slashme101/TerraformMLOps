data "azurerm_client_config" "current" {}

module "networking" {
    source = "./modules/networking"
    # resource_group_name = var.resource_group_name
    # location = var.location
}
module "aml" {
  source = "./modules/aml"
#   resource_group_name = var.resource_group_name
#   location = var.location
#   vnet_id = module.networking.vnet_id
  }

  module "aks" {
    source ="./modules/aks"
    # resource_group_name = var.resource_group_name
    # location = var.location
    # vnet_id = module.networking.vnet_id
  }

resource "azurerm_resource_group" "mlops_rg" {
    location = var.resource_group_location
    name = var.azure_rg_name
}

resource "azurerm_application_insights" "app_ins_ml" {
    name = var.application_insights_name
    location = azurerm_resource_group.mlops_rg.location
    resource_group_name = azurerm_resource_group.mlops_rg.name
    application_type = "web"
}

resource "azurerm_key_vault" "mlops_kv" {
    name = var.key_vault_name
    location = azurerm_resource_group.mlops_rg.location
    resource_group_name = azurerm_resource_group.mlops_rg.name
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "standard"
}

resource "azurerm_storage_account" "mlops_storage" {
    # Needs to be unique each time
    name = var.storage_account_name
    location = azurerm_resource_group.mlops_rg.location
    resource_group_name = azurerm_resource_group.mlops_rg.name
    account_tier = "Standard"
    account_replication_type = "LRS"   
}

