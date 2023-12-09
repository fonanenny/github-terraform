terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.82.0"
    }
  }
 backend "azurerm" {
    resource_group_name = "resource-group-backend-tfstate"
    storage_account_name = "sabetnqry"
    container_name = "storage-container-backend-tfstate"
    key = "backend.terraform.tfstate"

}
}

provider "azurerm" {
  features {
      key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
   }
}

resource "random_string" "random_string" {
  length = 4
  special = false
  upper = false
}

resource "azurerm_resource_group" "resource_group_backend" {
  name     = var.resource_group_backend_name
  location = var.resource_group_backend_location
}

resource "azurerm_storage_account" "storage_account_backend" {
  name                     = "${lower(var.storage_account_backend_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.resource_group_backend.name
  location                 = azurerm_resource_group.resource_group_backend.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

 }

resource "azurerm_storage_container" "storage_container_backend" {
  name                  = var.storage_container_backend_name
  storage_account_name  = azurerm_storage_account.storage_account_backend.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault_backend" {
  name                        = "${lower(var.key_vault_backend_name)}${random_string.random_string.result}"
  location                    = azurerm_resource_group.resource_group_backend.location
  resource_group_name         = azurerm_resource_group.resource_group_backend.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get","List","Create",
    ]

    secret_permissions = [
      "Get","Set","List",
    ]

    storage_permissions = [
      "Get","Set","List",
    ]
  }
}

resource "azurerm_key_vault_secret" "storage_account_backend_accesskey" {
  name         = var.storage_account_backend_accesskey_name
  value        = "azurerm_storage_account.storage_account_backend.primary_access_key"
  key_vault_id = azurerm_key_vault.key_vault_backend.id
}