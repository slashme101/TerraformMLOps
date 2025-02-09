resource "azurerm_machine_learning_workspace" "mlops_workspace" {
    name = "dev-mlops-workspace"
    location = azurerm_resource_group.mlops_rg.location
    resource_group_name = azurerm_resource_group.mlops_rg.name
    application_insights_id = azurerm_application_insights.app_ins_ml.id
    key_vault_id = azurerm_key_vault.mlops_kv.id
    storage_account_id = azurerm_storage_account.mlops_storage.id

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_storage_account" "mlops_storage" {
  name = "mlopsstorageacct"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}
# Storage ACcount for storing datasets, models and logs

# Key Vault for storing secrets, API keys, and credentials

# Application Insights for real-time monitoring and logging.