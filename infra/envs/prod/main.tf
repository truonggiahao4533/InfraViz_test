resource "azurerm_resource_group" "main" {
  name     = "rg-shop-prod"
  location = var.location
  tags     = local.tags
}
