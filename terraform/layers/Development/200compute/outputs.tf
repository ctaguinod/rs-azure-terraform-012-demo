###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF

  data "terraform_remote_state" "200compute" {
    backend = "azurerm"

    config = {
      storage_account_name = "${data.terraform_remote_state.main_state.outputs.terraform_storage_account_name}"
      container_name       = "${data.terraform_remote_state.main_state.outputs.terraform_storage_container_name}"
      key                  = "terraform.${lower(var.environment)}.200compute.tfstate"
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

## Outputs - 200compute layer

| TestVM | Value |
|---|---|
| availability_set_id | ${module.mytestvm.availability_set_id} |
| network_interface_private_ip | ${module.mytestvm.network_interface_private_ip[0]} |
| public_ip_address | ${module.mytestvm.public_ip_address[0]} |
| public_ip_dns_name | ${module.mytestvm.public_ip_dns_name[0]} |
| public_ip_id | ${module.mytestvm.public_ip_id[0]} |
| vm_ids | ${module.mytestvm.vm_ids[0]} |

EOF

  description = "Base Network Layer Outputs Summary `terraform output summary` "
}

###############################################################################
# VM Output
###############################################################################
