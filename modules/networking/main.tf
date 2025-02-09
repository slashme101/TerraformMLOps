resource "azurerm_virtual_network" "mlops_vnet" {
    name = var.vnet_name
    location = azurerm_resource_group.mlops_rg.location
    resource_group_name = azurerm_resource_group.mlops_rg.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "training_subnet" {
  name =  "training-subnet"
  virtual_network_name = azurerm_virtual_network.mlops_vnet.name
  resource_group_name = azurerm_resource_group.mlops_rg.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "scoring_subnet" {
  name = "scoring-subnet"
  resource_group_name = azurerm_resource_group.mlops_rg.name
  virtual_network_name = azurerm_virtual_network.mlops_vnet.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name = "private-endpoint-subnet"
  virtual_network_name = azurerm_virtual_network.mlops_vnet
  resource_group_name = azurerm_resource_group.mlops_rg.name
  address_prefixes = ["10.0.3.0/24"]
  # enforce_private_link_endpoint_network_policies = true 
}

resource "azurerm_subnet" "bastion_subnet" {
  name = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.mlops_vnet.name
  resource_group_name = azurerm_resource_group.mlops_rg.name
  address_prefixes = ["10.0.4.0/24"]
}

resource "azurerm_subnet" "gateway_subnet" {
  name = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.mlops_vnet.name
  resource_group_name = azurerm_resource_group.mlops_rg.name
  address_prefixes = ["10.0.5.0/24"]
}

resource "azurerm_subnet" "firewall_subnet" {
  name = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.mlops_vnet.name
  resource_group_name = azurerm_resource_group.mlops_rg.name
  address_prefixes = ["10.0.6.0/24"].name
}

resource "azurerm_private_endpoint" "mlops_private_endpoint" {
  name = "mlops-private-endpoint"
  location = azurerm_resource_group.mlops_rg.location
  resource_group_name = azurerm_resource_group.mlops_rg.name
  subnet_id = azurerm_subnet.private_endpoint_subnet.id
  
  private_service_connection {
    name = "mlops-privatelink"
    private_connection_resource_id = azurerm_machine_learning_workspace.mlops_storage_account.id
    is_manual_connection = false
    subresource_names = ["amlworkspace"]
  }
}

# Create NSG for Training Subnet
resource "azurerm_network_security_group" "training_nsg" {
  name = "training-nsg"
  location = azurerm_resource_group.mlops_rg.location
  resource_group_name = azurerm_resource_group.mlops_rg.name

  security_rule {
    name = "allow_ssh"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "training_nsg_association" {
  subnet_id = azurerm_subnet.training_subnet.id
  network_security_group_id = azurerm_network_security_group.training_nsg.id
}

# Creating NSG for SCoring Subnet
resource "azurerm_network_security_group" "scoring_nsg" {
  name = "scoring-nsg"
  location = azurerm_resource_group.mlops_rg.location
  resource_group_name = azurerm_resource_group.mlops_rg.name

  security_rule {
    name = "allow_http"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "scoring_nsg_association" {
  subnet_id = azurerm_subnet.scoring_subnet.id
  network_security_group_id = azurerm_network_security_group.scoring_nsg.id
}