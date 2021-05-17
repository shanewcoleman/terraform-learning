# ---------------------------------------------------------------
# Creating resource group
# ---------------------------------------------------------------

resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.resource_group_location

}
resource "azurerm_storage_account" "default" {
    name                        = "storageaccount${var.resource_group_name}"
    resource_group_name         = var.resource_group_name
    location                    = var.resource_group_location
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}
output "blob_endpoint" {
  value = azurerm_storage_account.default.primary_blob_endpoint
}
