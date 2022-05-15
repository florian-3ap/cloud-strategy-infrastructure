resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "aks_pods" {
  name                 = "${var.project_name}-aks-pods"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.1.0/24"]

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "pg_subnet" {
  name                 = "pg-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.2.0/24"]

  delegation {
    name = "pg-delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.project_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "pg_group_association" {
  subnet_id                 = azurerm_subnet.pg_subnet.id
  network_security_group_id = azurerm_network_security_group.default.id

  depends_on = [azurerm_subnet.pg_subnet, azurerm_network_security_group.default]
}

resource "azurerm_private_dns_zone" "default" {
  name                = "${var.project_name}-pdz.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_subnet_network_security_group_association.pg_group_association]
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${var.project_name}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group_name

  depends_on = [azurerm_private_dns_zone.default, azurerm_virtual_network.vnet]
}
