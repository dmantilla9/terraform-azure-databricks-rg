# This Terraform script creates an Azure Databricks workspace and two Azure Storage Accounts for Unity Catalog and Metastore.
# It uses the azurerm provider to manage Azure resources.

#main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

# Decodificar el archivo JSON
locals {
  subscription_data = jsondecode(file("${path.module}/subscription.json"))
}

provider "azurerm" {
  features {}

  subscription_id = local.subscription_data.id

}

# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
    tags = {
      environment = var._environment
      created_by  = var.created_by
    }
}

# Create a Databricks workspace
resource "azurerm_databricks_workspace" "adb" {
  name                = var.adb_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  managed_resource_group_name = "${var.resource_group_name}-infra"

  tags =  {
    environment = var._environment
    created_by  = var.created_by
  }
}

# Create Azure Storage Account for Unity Catalog DataLake
resource "azurerm_storage_account" "uc" {
  name                     = var.UnityCatalogStorageAccountName
  resource_group_name       = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind            = "StorageV2" # Required for Unity Catalog
  account_replication_type = "LRS"
  min_tls_version         = "TLS1_2"
  
  # Enable properties HNS only in accounts type StorageV2
  is_hns_enabled          = true

  tags = {
    environment = var._environment
    created_by  = var.created_by
  }
}

# Create Azure Storage Account for Metastore
resource "azurerm_storage_account" "metastore" {
  name                     = var.metastoreStorageAccountName
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var._environment
    created_by  = var.created_by
  }
  
}