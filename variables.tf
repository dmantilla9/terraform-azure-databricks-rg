# This file contains the variable definitions for the Terraform configuration.
# It defines the variables used in the configuration, including their types, descriptions, and default values.
# The variables defined in this file are used to create an Azure Databricks workspace and associated resources.

# variables.tf

variable "subscription" {
  description = "The Azure subscription ID"
  type        = any 
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default = "HandsOn"  
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "francecentral"
}

variable "sku" {
  description = "The SKU for the Databricks workspace"
  type        = string
  default     = "premium"
}

variable "_environment" {
  description = "The environment tag for resources"
  type        = string
  default     = "dev"
  
}

variable "created_by" {
  description = "The creator of the resources"
  type        = string
  default     = "Terraform"
  
}

variable "adb_workspace_name" {
  description = "The name of the Databricks workspace"
  type        = string
  default     = "adb-fr-tribu-databricks"
  
}

variable "UnityCatalogStorageAccountName" {
  description = "The name of the Unity Catalog storage account"
  type        = string
  default     = "asaadbunitycatalog"
  
}

variable "metastoreStorageAccountName" {
  description = "The key for the Unity Catalog storage account"
  type        = string
  default     = "asaadbmetastore"
  
}