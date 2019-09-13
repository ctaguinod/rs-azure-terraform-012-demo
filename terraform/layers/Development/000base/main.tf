###############################################################################
#########################       000base Layer         #########################
###############################################################################

###############################################################################
# Providers
###############################################################################
provider "azurerm" {
  version         = ">=1.33"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

locals {
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}

###############################################################################
# Use Terraform Version 0.12
# Obtain storage access_key from storage account or 
# az storage account keys list -g MyResourceGroup -n MyStorageAccount
# Linux:   export ARM_ACCESS_KEY=XXXXXYYYYYYY
# Windows: $env:ARM_ACCESS_KEY="XXXYYY"
###############################################################################

terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    storage_account_name = "rackspace3557db9b"
    container_name       = "terraform-state"
    key                  = "terraform.development.000base.tfstate"
  }
}

###############################################################################
# Terraform Remote State 
###############################################################################
data "terraform_remote_state" "main_state" {
  backend = "local"

  config = {
    path = "../../_main/terraform.tfstate"
  }
}

###############################################################################
# VNET
###############################################################################
locals {
  # Resource Group Name
  resource_group_name = var.resource_group_name

  # location / region
  location = var.location

}

module "vnet" {
  source              = "../../../modules/vnet/"
  resource_group_name = local.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_prefixes     = [var.gateway_subnet_prefix, var.bastion_subnet_prefix, var.frontend_subnet_prefix, var.app_subnet_prefix, var.db_subnet_prefix, var.dmz_subnet_prefix]
  subnet_names        = [var.gateway_subnet_name, var.bastion_subnet_name, var.frontend_subnet_name, var.app_subnet_name, var.db_subnet_name, var.dmz_subnet_name]

  tags = local.tags
}

locals {
  vnet_id            = module.vnet.vnet_id
  subnet_ids         = module.vnet.vnet_subnets
  gateway_subnet_id  = module.vnet.vnet_subnets[0]
  bastion_subnet_id  = module.vnet.vnet_subnets[1]
  frontend_subnet_id = module.vnet.vnet_subnets[2]
  app_subnet_id      = module.vnet.vnet_subnets[3]
  db_subnet_id       = module.vnet.vnet_subnets[4]
  dmz_subnet_id      = module.vnet.vnet_subnets[5]
}

###############################################################################
# NSG
###############################################################################

# Rackspace Bastion
module "rbast_nsg" {
  source            = "../../../modules/rbast-nsg/"
  nsg_name          = "${var.bastion_subnet_name}-NSG"
  nsg_location      = var.location
  nsg_rsg           = local.resource_group_name
  nsg_subnet_prefix = var.bastion_subnet_prefix
}

# Attach Rbast NSG to Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "rbast_nsg" {
  subnet_id                 = local.bastion_subnet_id
  network_security_group_id = module.rbast_nsg.nsg_id
}

locals {
  rbast_nsg_id = module.rbast_nsg.nsg_id
}

# Attach Frontend NSG to Frontend Subnet
resource "azurerm_subnet_network_security_group_association" "frontend_subnet" {
  subnet_id                 = local.frontend_subnet_id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

# Attach App NSG to App Subnet
resource "azurerm_subnet_network_security_group_association" "app_subnet" {
  subnet_id                 = local.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# Attach DB NSG to DB Subnet
resource "azurerm_subnet_network_security_group_association" "db_subnet" {
  subnet_id                 = local.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

# Attach DMZ NSG to DMZ Subnet
resource "azurerm_subnet_network_security_group_association" "dmz_subnet" {
  subnet_id                 = local.dmz_subnet_id
  network_security_group_id = azurerm_network_security_group.dmz_nsg.id
}
