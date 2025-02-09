resource "azurerm_kubernetes_cluster" "mlops_aks" {
  name = "mlops-aks"
  location = azurerm_resource_group.mlops_rg.location
  resource_group_name = azurerm_resource_group.mlops_rg.name
  dns_prefix = "mlops"

  default_node_pool {
    name = "default"
    node_count = 2
    vm_size = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.training_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}

# AKS runs inside the Training Subnet for secure, scalable ML Workloads
# System-assigned identity for Azure role-based access