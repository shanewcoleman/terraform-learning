# ---------------------------------------------------------------
# Create virtual network 
# ---------------------------------------------------------------

resource "azurerm_virtual_network" "default" {
  name                = "${var.rg_name}-vnet"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

## Create subnet

resource "azurerm_subnet" "default" {
  name                 = "${var.rg_name}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ---------------------------------------------------------------
## Create network security group / dynamic rules
# ---------------------------------------------------------------

resource "azurerm_network_security_group" "default" {
  name                = "${var.rg_name}-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = [for x in var.network_rules : {
      name                       = x.name
      priority                   = x.priority
      direction                  = x.direction
      access                     = x.access
      protocol                   = x.protocol
      source_port_ranges         = split(",", replace(x.source_port_ranges, "*", "0-65535"))
      destination_port_ranges    = split(",", replace(x.destination_port_ranges, "*", "0-65535"))
      source_address_prefix      = x.source_address_prefix
      destination_address_prefix = x.destination_address_prefix
      description                = x.description
    }]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_ranges         = security_rule.value.source_port_ranges
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }
}

# ---------------------------------------------------------------
# Node NIC and Public IP
# ---------------------------------------------------------------

resource "azurerm_public_ip" "node" {
  count = var.num
  name                = "${var.rg_name}-node-pip${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "node" {
  count = var.num
  name                = "${var.rg_name}-node-inet${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  
  ip_configuration {
    name                          = "${var.rg_name}-node-ip${count.index}"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.node[count.index].id
  }
}


# ---------------------------------------------------------------
# Connect the security group to the network interface
# ---------------------------------------------------------------

resource "azurerm_network_interface_security_group_association" "node" {
  count = var.num
  network_interface_id      = azurerm_network_interface.node[count.index].id
  network_security_group_id = azurerm_network_security_group.default.id
}



output network_ids {
  value = ["${azurerm_network_interface.node.*.id}"]

}