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

###############################################################################
# Use Terraform Version 0.12
###############################################################################
terraform {
  required_version = ">= 0.12"
}

###############################################################################
# Storage for Terraform state
###############################################################################
resource "random_id" "storage" {
  byte_length = 4
}

locals {
  # Add additional tags in the below map
  tags = {
    ServiceProvider = "Rackspace"
  }

  # Random id
  random_id = "${lower(random_id.storage.hex)}"

  # Resource Group Name
  resource_group_name = var.resource_group_name
}

# Resource Group - Prod
resource "azurerm_resource_group" "terraform_state" {
  location = var.location
  name     = local.resource_group_name
  tags     = local.tags
}

# Storage Account
resource "azurerm_storage_account" "terraform_state" {
  name                     = "rackspace${local.random_id}"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = ["azurerm_resource_group.terraform_state"]
  tags                     = local.tags
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}
