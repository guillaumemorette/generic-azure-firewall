# --------------------- Firewall ------------------------------
variable location {}
variable resource-group {}
variable vnet-name {}
variable firewall-name {}
variable public-ip-name {}

resource "azurerm_subnet" "fw-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource-group
  virtual_network_name = var.vnet-name
  address_prefix       = var.subnet-cidr
}

resource "azurerm_public_ip" "public-ip" {
  name                = var.public-ip-name
  location            = var.location
  resource_group_name = var.resource-group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "dnat-fw" {
  name                = var.firewall-name
  location            = var.location
  resource_group_name = var.resource-group

  ip_configuration {
    name                 = "ip-configuration"
    subnet_id            = azurerm_subnet.fw-subnet.id
    public_ip_address_id = azurerm_public_ip.public-ip.id
  }
}
