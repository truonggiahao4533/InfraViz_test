resource "azurerm_resource_group" "main" {
  name     = "rg-shop-dev"
  location = var.location
  tags     = local.tags
}
