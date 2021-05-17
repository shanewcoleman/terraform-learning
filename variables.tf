variable public_key {
    type= string
    default = "~/.ssh/id_rsa.pub"
}

variable private_key{
    type = string
    default = "~/.ssh/id_rsa"

}
variable resource_group_location  {
    type = string
    default = "eastus"
}

variable disable_password_auth {
    type = bool
    default = true
}
variable resource_group_name {
    type = string
    default = "rgname"
}

variable nodes {
default = 3

}

variable microservice_machine_size {
    default = "small"
    }

variable admin_username {
    default= "localadmin"
}

variable disable_password_authentication {
    default=true
}

variable os_image_map {
    description = "a map for OS Images in the Azure MKTPLC"
    type = map 
    default = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "8.2"
      version   = "latest" }
    }

variable network_rules {
    type = list(map(string))
    default = [{
      name                       = "default"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "<insert desired cidr range here>"
      destination_address_prefix = "*"
      description                = "Allow traffic from a desired network."
    }]
}