# Setup for "/opt"
resource "azurerm_managed_disk" "optmount" {
  name                 = "${var.node_machine_name}-disk1"
  location             = var.rg_location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_virtual_machine_data_disk_attachment" "opt" {
  managed_disk_id    = azurerm_managed_disk.optmount.id
  virtual_machine_id = var.vm_id
  lun                = "10"
  caching            = "ReadWrite"
}

# Setup for "/var/cache"
resource "azurerm_managed_disk" "varcache" {
  name                 = "${var.node_machine_name}-disk2"
  location             = var.rg_location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 80
}

resource "azurerm_virtual_machine_data_disk_attachment" "varcache" {
  managed_disk_id    = azurerm_managed_disk.varcache.id
  virtual_machine_id = var.vm_id
  lun                = "20"
  caching            = "ReadWrite"
}

# Setup for /cache
resource "azurerm_managed_disk" "optcache" {
  name                 = "${var.node_machine_name}-disk3"
  location             = var.rg_location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 300
}

resource "azurerm_virtual_machine_data_disk_attachment" "optcache" {
  managed_disk_id    = azurerm_managed_disk.optcache.id
  virtual_machine_id = var.vm_id
  lun                = "30"
  caching            = "ReadWrite"
}

