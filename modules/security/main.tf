# ---------------------------------------------------------------
# Creating key vault
# ---------------------------------------------------------------

resource "azurerm_key_vault" "secret" {
  name                            = var.name
  location                        = var.rg_location
  resource_group_name             = var.rg_name
  enabled_for_disk_encryption     = true
  tenant_id                       = var.tenant_id
  purge_protection_enabled        = false
  enabled_for_template_deployment = true
  enabled_for_deployment          = true

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "dde-azure-kv-secret"
  value        = base64encode(file(var.private_key))
  key_vault_id = azurerm_key_vault.secret.id
}

# ---------------------------------------------------------------
# Retrive Private Key
# ---------------------------------------------------------------

data "azurerm_key_vault" "vault" {
  name                = azurerm_key_vault.secret.name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault_secret" "vault" {
  name         = azurerm_key_vault_secret.secret.name
  key_vault_id = data.azurerm_key_vault.vault.id
}

resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "echo '${data.azurerm_key_vault_secret.vault.value}' | base64 -d > ${var.private_key}"

    environment = {
      private_key = var.private_key
    }
  }
  provisioner "local-exec" {
    command = "chmod 600 ${var.private_key}"

    environment = {
      private_key = var.private_key
    }
  }
}
