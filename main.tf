
data "azurerm_client_config" "current" {}

provider "azurerm" {
  version = "=2.42.0"
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    key_vault {
      recover_soft_deleted_key_vaults = false
      purge_soft_delete_on_destroy    = false
    }
  }
}

module "resource_group"{
    source = "./modules/resource_group"
    resource_group_name = "${var.resource_group_name}"
    resource_group_location = var.resource_group_location
}

module "security" {
    source = "./modules/security"
    name = "keyvault-${var.resource_group_name}"
    tenant_id =  data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    rg_name = var.resource_group_name
    rg_location = var.resource_group_location
    private_key = var.private_key
}

module "network"{
    num = var.nodes
    source = "./modules/network"
    rg_name = var.resource_group_name
    rg_location = var.resource_group_location
    default_cidr = var.default_cidr
    network_rules = var.network_rules
}
module "compute"{
    count = var.nodes
    source = "./modules/compute"
    admin_username = var.admin_username
    size = var.microservice_machine_size
    storage_uri = module.resource_group.blob_endpoint
    rg_name = var.resource_group_name
    rg_location = var.resource_group_location
    network_id = [module.network.network_ids[0][count.index]]
    os_image_map = var.os_image_map
    passwd_disable = var.disable_password_auth
    os_disk_name = "vdisk-${count.index}"
    instance_name = "node-instance${count.index}"
    computer_name = "node${count.index}${var.resource_group_name}"
    public_key = var.public_key
}
module "storage"{
    count = var.nodes
    source = "./modules/storage"
    machine_name = module.compute[count.index].vm_name
    vm_id = module.compute[count.index].vm_id
    rg_name = var.resource_group_name
    rg_location = var.resource_group_location
}
