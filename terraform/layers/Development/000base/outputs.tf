###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF

  data "terraform_remote_state" "base_network" {
    backend = "azurerm"

    config = {
      storage_account_name = "${data.terraform_remote_state.main_state.outputs.terraform_storage_account_name}"
      container_name       = "${data.terraform_remote_state.main_state.outputs.terraform_storage_container_name}"
      key                  = "terraform.${lower(var.environment)}.000base.tfstate"
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

## Outputs - 000base layer

| Base Network | Value |
|---|---|
| vnet_id | ${module.vnet.vnet_id} |
| vnet_address_space | ${module.vnet.vnet_address_space[0]} |
| gateway_subnet_id | ${module.vnet.vnet_subnets[0]} |
| bastion_subnet_id | ${module.vnet.vnet_subnets[1]} |
| frontend_subnet_id | ${module.vnet.vnet_subnets[2]} |
| app_subnet_id | ${module.vnet.vnet_subnets[3]} |
| db_subnet_id | ${module.vnet.vnet_subnets[4]} |
| dmz_subnet_id | ${module.vnet.vnet_subnets[5]} |

EOF

  description = "Base Network Layer Outputs Summary `terraform output summary` "
}


###############################################################################
# Base Network Output
###############################################################################
output "vnet" {
  value       = module.vnet
  description = "VNET Output"
}
