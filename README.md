# Terraform 0.12 Demo
Provision [Azure](https://azure.microsoft.com/en-us/) infrastrucutre with [Terraform 0.12](https://www.terraform.io/), bake image using [Packer](https://packer.io/) and [chef-solo](https://www.packer.io/docs/provisioners/chef-solo.html) provisioner.


Clone the repo.
```
git clone git@github.com:ctaguinod/rs-azure-terraform-012-demo.git
cd rs-azure-terraform-012-demo
```

## Provision ***_main*** layer
- This layer will provision the Storage account and Container for terraform state.

1. Create `terraform.tfvars` and `secrets.tfvars` from sample file and fill in with correct parameters
```
cd terraform/layers/_main/
cp terraform.tfvars-example terraform.tfvars
cp secrets.tfvars-example secrets.tfvars
```

2. Initialise and apply
```
terraform init
terraform apply --var-file=secrets.tfvars
```

3. Run `terraform output state_import_example` to display sample remote state import config.

4. Run `terraform output remote_state_configuration_example` to display sample remote state config.

5. Run `terraform output storage_account_access_key` to to obtain the Storage Account Access Key for the terraform State and run `export ARM_ACCESS_KEY=RANDOMEACCESSKEYHERE` to set environment variable for the other layeres to have access to the terraform state.


## Provision ***000base*** layer
- This layer will provision the base infrastructure such as **VNET**, **SUBNETS** and **NSGs**.

1. Create `terraform.tfvars` from sample file and fill in with correct parameters.
```
cd ../Development/000base/
cp terraform.tfvars-example terraform.tfvars
```

2. Modify `main.tf` and update correct parameters as needed. Make sure to update the section for the correct `storage_account_name`, `container_name` and `key` for the Terraform state. You can run `terraform output remote_state_configuration_example` from the `_main` layer to get example config.

3. Run `export ARM_ACCESS_KEY=RANDOMEACCESSKEYHERE` to have access to remote terraform state.

4. Initialise and apply
```
terraform init
terraform apply --var-file=../../_main/secrets.tfvars
```

4. Run `terraform output state_import_example` to display sample remote state import config.

5. Run `terraform output summary` to display resources outputs.


## Bake a Windows 2016 Image using Packer and chef-solo

1. Set environment variables for the `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID` and `ARM_TENANT_ID`, details can be aquired from the Azure portal.

```
export ARM_CLIENT_ID="AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE"
export ARM_CLIENT_SECRET="ABCDEFGHIJKLMNOPQRSTUVWXYZ123454"
export ARM_SUBSCRIPTION_ID="BBBBBBBB-CCCC-DDDD-EEEE-FFFFFFFFFFFF"
export ARM_TENANT_ID="CCCCCCCC-DDDD-EEEE-FFFF-GGGGGGGGGGGG"
```

2. Create a `packer.json` file from provided example and update correct parameters as needed. Run `packer validate` and if all looks good run `packer build`.

```
cd ../../../../packer/
cp packer-azure-win2016-chef.json-example packer-azure-win2016-chef.json
packer validate packer-azure-win2016-chef.json
packer build packer-azure-win2016-chef.json
```

3. Get the resource id of the baked image `az image list -o tsv` 


## Provision ***200compute*** layer
- This layer will provision a Virtuak Machine from the pre-baked image created with Packer and chef from the previous section.

1. Create `terraform.tfvars` from sample file and fill in with correct parameters.
```
cd ../terraform/layers/Development/200compute/
cp terraform.tfvars-example terraform.tfvars
```

2. Modify `main.tf` and update correct parameters as needed. Make sure to update the section for the correct `storage_account_name`, `container_name` and `key` for the Terraform state. You can run `terraform output remote_state_configuration_example` from the `_main` layer to get example config.

3. Run `export ARM_ACCESS_KEY=RANDOMEACCESSKEYHERE` to have access to remote terraform state.

4. Initialise and apply
```
terraform init
terraform apply --var-file=../../_main/secrets.tfvars
```

4. Run `terraform output state_import_example` to display sample remote state import config.

5. Run `terraform output summary` to display resources outputs.


## Destroying the test environment.

1. Destroy **200compute** layer. 
```
cd terraform/layers/Development/200compute/
terraform destroy --var-file=../../_main/secrets.tfvars
```

2. Destroy **100data** layer. 
```
cd ../100data
terraform destroy --var-file=../../_main/secrets.tfvars
```

3. Destroy **000base** layer. 
```
cd ../000base
terraform destroy --var-file=../../_main/secrets.tfvars
```

4. Destroy **_main** layer. 
```
cd ../../_main
terraform destroy --var-file=secrets.tfvars
```