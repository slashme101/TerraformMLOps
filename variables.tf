variable "resource_group_location" {
  type = string
  default = "eastus"
  description = "Location of the resource group"
}

variable "azure_rg_name" {
  type = string
  default = "ml-rg-krunetworx-dev"
  description = "Prefix of the resource group name that's combined with a random ID to make the name unique on azure subscription"
}

variable "application_insights_name" {
  type = string

}

variable "key_vault_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}