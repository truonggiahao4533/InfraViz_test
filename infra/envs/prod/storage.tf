resource "azurerm_storage_account" "storage" {
  name                              = "stshopprod"
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  account_tier                      = "Standard"
  account_replication_type          = "ZRS"
  min_tls_version                   = "TLS1_2"
  https_traffic_only_enabled        = true
  allow_nested_items_to_be_public   = false
  public_network_access             = "Disabled"
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
  tags = local.tags
}
