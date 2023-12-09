locals {
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  resource_group_name    = terraform.workspace == "default" ? "${var.resource_group_name}" : "${var.resource_group_name}-${local.workspace_suffix}"
  storage_account_name    = terraform.workspace == "default" ? "${var.storage_account_name}" : "${var.storage_account_name}${local.workspace_suffix}"
  web_suffix = "<h1>${terraform.workspace}</h1>"
}

resource "random_string" "random_string" {
  length  = 4
  special = false
  upper   = false
}

# Create Resource Group
resource "azurerm_resource_group" "resource_group_web" {
  name     = local.resource_group_name
  location = var.location
}

# Create Storage Account
resource "azurerm_storage_account" "storage_account_web" {
  name                     = "${lower(local.storage_account_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.resource_group_web.name
  location                 = azurerm_resource_group.resource_group_web.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.index_document
  }
}

# Add a index.html file to the storage account
resource "azurerm_storage_blob" "index_html" {
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.storage_account_web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "${var.source_content_web}${local.web_suffix}"
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.storage_account_web.primary_web_endpoint
}