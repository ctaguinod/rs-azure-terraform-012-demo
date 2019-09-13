###############################################################################
# Environment
###############################################################################

variable "subscription_name" {
  description = "Enter Subscription Name for provisioning resources in Azure"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}
variable "location" {
  description = "Azure region the environment."
  default     = "Southeast Asia"
}

variable "environment" {
  description = "Name of the environment for the deployment, e.g. Integration, PreProduction, Production, QA, Staging, Test"
  default     = "Development"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

###############################################################################
# VNET
###############################################################################

variable "vnet_name" {
  description = "VNET Name"
  default     = "SEA-VNET01"
}

variable "address_space" {
  description = "VNET Address Space"
  default     = "172.18.0.0/16"
}

variable "gateway_subnet_prefix" {
  description = "GatewaySubnet Prefix"
  default     = "172.18.1.0/27"
}

variable "gateway_subnet_name" {
  description = "GatewaySubnet Name"
  default     = "GatewaySubnet"
}

variable "bastion_subnet_prefix" {
  description = "RAX Bastion Subnet Prefix"
  default     = "172.18.2.0/24"
}

variable "bastion_subnet_name" {
  description = "RAX Bastion Subnet Name"
  default     = "RAX-BASTION-SUBNET"
}

variable "frontend_subnet_prefix" {
  description = "Frontend Subnet Prefix"
  default     = "172.18.3.0/24"
}

variable "frontend_subnet_name" {
  description = "Frontend Subnet Name"
  default     = "FRONTEND-SUBNET"
}

variable "app_subnet_prefix" {
  description = "App Subnet Prefix"
  default     = "172.18.4.0/24"
}

variable "app_subnet_name" {
  description = "App Subnet Name"
  default     = "APP-SUBNET"
}

variable "db_subnet_prefix" {
  description = "DB Subnet Prefix"
  default     = "172.18.5.0/24"
}

variable "db_subnet_name" {
  description = "DB Subnet Name"
  default     = "DB-SUBNET"
}

variable "dmz_subnet_prefix" {
  description = "DMZ Subnet Prefix"
  default     = "172.18.6.0/24"
}

variable "dmz_subnet_name" {
  description = "DMZ Subnet Name"
  default     = "DMZ-SUBNET"
}
