resource "azurerm_linux_virtual_machine" "node" {
    name                  = var.instance_name
    location              = var.rg_location
    resource_group_name   = var.rg_name
    network_interface_ids = var.network_id
    size                  = var.instance_type_map[var.size]

    os_disk {
      name              = var.os_disk_name
      caching           = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference { 
      publisher = var.os_image_map.publisher
      offer = var.os_image_map.offer
      sku = var.os_image_map.sku
      version = var.os_image_map.version
      }

    computer_name                   = var.computer_name
    admin_username                  = var.admin_username
    disable_password_authentication = var.passwd_disable

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key)
  }

    boot_diagnostics {
      storage_account_uri = var.storage_uri
    }

}

output "vm_name" {
  value = element(concat(azurerm_linux_virtual_machine.node.*.name, [""]),0)
  #value = join(", ",azurerm_linux_virtual_machine.node.*.name)
}

output "vm_id" {
  value = element(concat(azurerm_linux_virtual_machine.node.*.id, [""]),0)
  #value = join(", ",azurerm_linux_virtual_machine.node.*.id)
}