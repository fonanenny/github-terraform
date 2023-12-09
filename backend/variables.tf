variable "resource_group_backend_name" {
    type = string
    description = "Name of the resource group for backend"
}

variable "resource_group_backend_location" {
    type = string
    description = "Location of the resource group for backend"
}

variable "storage_account_backend_name" {
    type = string
    description = "Name of the storage account for backend"
}

variable "storage_container_backend_name" {
    type = string
    description = "Name of the storage container for backend"
}

variable "storage_account_backend_accesskey_name" {
    type = string
    description = "Name of the storage account for backend accesskey name"
}

variable "key_vault_backend_name" {
    type = string
    description = "Name of the key vault for backend"
}