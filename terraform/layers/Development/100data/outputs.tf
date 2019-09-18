###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF

  data "terraform_remote_state" "100data" {
    backend = "azurerm"

    config = {
      storage_account_name = "${data.terraform_remote_state.main_state.outputs.terraform_storage_account_name}"
      container_name       = "${data.terraform_remote_state.main_state.outputs.terraform_storage_container_name}"
      key                  = "terraform.${lower(var.environment)}.100data.tfstate"
    }
  }
EOF
}

###############################################################################
# Summary Output
# terraform output summary
###############################################################################
output "summary" {
  value = <<EOF

## Outputs - 100data layer

| * | Value |
|---|---|
| storage_account_name | ${azurerm_storage_account.storage.name} |
| storage_container_name | ${azurerm_storage_container.storage.name} |

EOF

  description = "Data Layer Outputs Summary `terraform output summary` "
}
