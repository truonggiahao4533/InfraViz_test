resource "azurerm_key_vault" "kv" {
  name                          = "kv-shop-prod"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  sku_name                      = "standard"
  tenant_id                     = var.tenant_id
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = false
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
  tags = local.tags
}
