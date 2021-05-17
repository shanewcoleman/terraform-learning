variable rg_name {
    type = string
}

variable computer_name {
    type = string
}

variable instance_name {
    type = string
}

variable os_disk_name {
    type = string
}

variable network_id{
    type = list
}

variable rg_location{
    type = string 
}

variable os_image_map {
    description = "The image to map to the server"
    type = map
} 
variable admin_username {
    description = "The Administrator Username"
    type = string
    
}
variable passwd_disable {
    type = bool
}

variable size {

    type = string

    
}

variable instance_type_map {

    description = "A map from environment to the type of EC2 instance"
    type = map
    default = {
        small  = "Standard_D2ds_v4"
        medium = "Standard_D16ds_v4"
        large  = "Standard_D32ds_v4"
  }
}

variable storage_uri {
    type = string
}

variable public_key {
    type = string
}