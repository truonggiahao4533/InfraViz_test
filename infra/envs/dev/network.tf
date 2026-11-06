resource "azurerm_virtual_network" "main" {
  name                = "vnet-shop-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                            = "snet-shop-dev"
  resource_group_name             = azurerm_virtual_network.main.resource_group_name
  virtual_network_name            = azurerm_virtual_network.main.name
  address_prefixes                = ["10.0.0.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "subnet_2" {
  name                            = "snet-shop-dev-2"
  resource_group_name             = azurerm_virtual_network.main.resource_group_name
  virtual_network_name            = azurerm_virtual_network.main.name
  address_prefixes                = ["10.0.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob" {
  name                 = "link-shop-dev-storage-blob"
  private_dns_zone_id  = azurerm_private_dns_zone.storage_blob.id
  virtual_network_id   = azurerm_virtual_network.main.id
  registration_enabled = false
  tags                 = local.tags
}

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-shop-dev-storage-blob"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.subnet_2.id
  private_service_connection {
    name                           = "blob"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_blob.id]
  }
  tags = local.tags
}

resource "azurerm_private_dns_zone" "kv_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_vault" {
  name                 = "link-shop-dev-kv-vault"
  private_dns_zone_id  = azurerm_private_dns_zone.kv_vault.id
  virtual_network_id   = azurerm_virtual_network.main.id
  registration_enabled = false
  tags                 = local.tags
}

resource "azurerm_private_endpoint" "kv_vault" {
  name                = "pe-shop-dev-kv-vault"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.subnet_2.id
  private_service_connection {
    name                           = "vault"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_vault.id]
  }
  tags = local.tags
}
