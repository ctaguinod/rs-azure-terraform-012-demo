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

  # Blob Storage
  blob_storage = "blobstorage"

  # Random id
  random_id = "${lower(random_id.storage.hex)}"
}

resource "random_id" "storage" {
  byte_length = 4
}

###############################################################################
# RSG
###############################################################################

# Resource Group
resource "azurerm_resource_group" "rsg" {
  location = var.location
  name     = local.resource_group_name
  tags     = local.tags
}

###############################################################################
# Blob Storage
###############################################################################

resource "azurerm_storage_account" "storage" {
  name                     = "rackspace${local.random_id}"
  resource_group_name      = azurerm_resource_group.rsg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = ["azurerm_resource_group.rsg"]
  tags                     = local.tags
}

resource "azurerm_storage_container" "storage" {
  name                  = "test-data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
