terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "resource-group-be-tfstate"
    storage_account_name = "sabetf8f7t6"
    container_name = "storage-container-be-tfstate"
    key = "web.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}