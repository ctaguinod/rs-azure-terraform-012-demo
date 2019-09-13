###############################################################################
#########################       200compute Layer         #########################
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
    key                  = "terraform.development.200compute.tfstate"
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

data "terraform_remote_state" "base_network" {
  backend = "azurerm"

  config = {
    storage_account_name = "rackspace3557db9b"
    container_name       = "terraform-state"
    key                  = "terraform.development.000base.tfstate"
  }
}

locals {
  vnet_id            = data.terraform_remote_state.base_network.outputs.vnet.vnet_id
  subnet_ids         = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets
  gateway_subnet_id  = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[0]
  bastion_subnet_id  = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[1]
  frontend_subnet_id = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[2]
  app_subnet_id      = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[3]
  db_subnet_id       = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[4]
  dmz_subnet_id      = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[5]
}

###############################################################################
# Locals
###############################################################################
locals {
  # Resourece Group  
  resource_group_name = var.resource_group_name

  # location / region
  location = var.location

  # Subnet ID
  vnet_subnet_id = local.frontend_subnet_id

  # Custom Windows Image
  vm_os_id = var.vm_os_id
}

###############################################################################
# RSG
###############################################################################

# Resource Group - Web
resource "azurerm_resource_group" "web" {
  location = var.location
  name     = local.resource_group_name
  tags     = local.tags
}

###############################################################################
# VM
###############################################################################

module "mytestvm" {
  source                       = "../../../modules/terraform-azurerm-compute/"
  resource_group_name          = local.resource_group_name
  location                     = local.location
  vnet_subnet_id               = local.vnet_subnet_id
  vm_hostname                  = "mytestvm" // line can be removed if only one VM module per resource group
  admin_username               = "mytestvm"
  admin_password               = "ComplxP@ssw0rd!"
  public_ip_dns                = ["mytestvm"] // change to a unique name per datacenter region
  public_ip_address_allocation = "Dynamic"
  nb_public_ip                 = "1"
  nb_instances                 = "1"
  vm_os_simple                 = "WindowsServer"
  vm_os_publisher              = "MicrosoftWindowsServer"
  vm_os_offer                  = "WindowsServer"
  vm_size                      = "Standard_B2s"
  vm_os_id                     = local.vm_os_id
  is_windows_image             = "true"
  storage_account_type         = "Standard_LRS"
  tags                         = local.tags
}

output "mytestvm" {
  value       = module.mytestvm
  description = "mytestvm Output"
}

