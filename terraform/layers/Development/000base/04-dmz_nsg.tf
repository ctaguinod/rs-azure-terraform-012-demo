resource "azurerm_network_security_group" "dmz_nsg" {
  name                = "${var.dmz_subnet_name}-NSG"
  location            = var.location
  resource_group_name = local.resource_group_name

  ### Custom Rules

  security_rule {
    name                       = "Allow-Public-WinRM-Inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefixes    = ["0.0.0.0/0"]
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_ranges    = ["5985", "5986"]
  }

  security_rule {
    name                       = "Allow-Public-HTTP-Inbound"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefixes    = ["0.0.0.0/0"]
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_ranges    = ["80", "443"]
  }

  security_rule {
    name                       = "Allow-Public-RDP-Inbound"
    priority                   = 302
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefixes    = ["0.0.0.0/0"]
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_ranges    = ["3389"]
  }

  ### Standard Rules

  security_rule {
    name                       = "Allow_LOCAL_SUBNET_INBOUND"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = var.dmz_subnet_prefix
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "Allow_AZURE_LB_INBOUND"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_RDP_INBOUND"
    priority                   = 112
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "3389"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_SSH_INBOUND"
    priority                   = 113
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_WinRM_INBOUND"
    priority                   = 114
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "5986"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_SFTBROKER_INBOUND"
    priority                   = 115
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.dmz_subnet_prefix
    destination_port_range     = "4421"
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

output "dmz_nsg_id" {
  value = azurerm_network_security_group.dmz_nsg.id
}
