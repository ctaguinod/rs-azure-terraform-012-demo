###############################################################################
# Outputs
# terraform output remote_state_configuration_example
# key must be unique for each layer!
###############################################################################
output "remote_state_configuration_example" {
  value = <<EOF

  terraform {
    required_version = ">= 0.12"

    backend "azurerm" {
      # this key must be unique for each layer!
      storage_account_name = "${azurerm_storage_account.terraform_state.name}"
      container_name       = "${azurerm_storage_container.terraform_state.name}"
      key                  = "terraform.EXAMPLE.000base.tfstate"
    }
  }
EOF

  description = "A suggested terraform block to put into the build layers. `terraform output remote_state_configuration_example`"
}

output "terraform_storage_account_name" {
  value       = azurerm_storage_account.terraform_state.name
  description = "The Storage Account to be used for state files."
}

output "terraform_storage_container_name" {
  description = "The Storage Container to be used for state files."
  value       = azurerm_storage_container.terraform_state.name
}

###############################################################################
# Outputs
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  value = <<EOF

  data "terraform_remote_state" "main_state" {
    backend = "local"

    config = {
      path = "../../_main/terraform.tfstate"
    }
  }
EOF

  description = "An example to use this layers state in another. `terraform output state_import_example`"
}

###############################################################################
# Outputs
# Obtain storage access_key from storage account
# terraform output storage_account_access_key
###############################################################################
output "storage_account_access_key" {
  value = <<EOF
  Run the following command to obtain the Storage Account Access Key for the terraform State:
  
  az storage account keys list -g ${var.resource_group_name} -n ${azurerm_storage_account.terraform_state.name}


EOF

  description = "Obtain storage access_key from storage account. `terraform output storage_account_access_key`"
}
