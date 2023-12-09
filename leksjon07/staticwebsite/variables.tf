variable "location" {
  type        = string
  description = "Location of the resource"
  default     = "westeurope"
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "resource-group-web"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  default     = "storage-account-web"
}

variable "source_content_web" {
  type        = string
  description = "Source content for the index.html file"
  default     = "<h1>Made with Terraform </h1>"
}

variable "index_document" {
  type        = string
  description = "Name of the index document"
  default     = "index.html"
}