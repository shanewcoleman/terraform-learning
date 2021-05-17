variable num {
  type = number
}

variable rg_name {
    type = string

}

variable rg_location {
    type = string
}


#Network rules
variable "network_rules" {
  type    = list(map(string))

}