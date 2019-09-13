resource "azurerm_network_security_group" "rs_bastion_nsg_module" {
  name                = var.nsg_name
  location            = var.nsg_location
  resource_group_name = var.nsg_rsg

  security_rule {
    name                       = "Allow_RAX_SSH_DFW"
    priority                   = 151
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "172.99.99.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_IAD"
    priority                   = 152
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "146.20.2.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_ORD"
    priority                   = 153
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "161.47.0.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_HKG"
    priority                   = 154
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "119.9.122.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_LON"
    priority                   = 155
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "134.213.179.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_LON5"
    priority                   = 156
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "134.213.178.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_SYD"
    priority                   = 157
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "119.9.148.10/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PDFW"
    priority                   = 179
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "72.3.186.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PIAD"
    priority                   = 183
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "146.20.30.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PORD"
    priority                   = 187
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "161.47.6.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PHKG"
    priority                   = 191
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "120.136.39.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PLON"
    priority                   = 195
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "134.213.183.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PLON5"
    priority                   = 199
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "134.213.182.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_RAX_SSH_PSYD"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "119.9.163.100/32"
    destination_address_prefix = var.nsg_subnet_prefix
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Deny_ALL_INBOUND_UDP"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "UDP"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "Deny_ALL_INBOUND_TCP"
    priority                   = 4001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

