# 🚀 Azure Databricks Infrastructure Deployment with Terraform

This Terraform project automates the creation of an Azure Databricks workspace, a resource group, and storage accounts for Unity Catalog and Metastore.

## 🌐 Overview

This infrastructure includes:
- Azure Resource Group
- Azure Databricks Workspace (`Premium` tier)
- Storage Account for Unity Catalog (Data Lake Gen2)
- Storage Account for Unity Catalog Metastore

## ⚙️ Variables

You can configure the deployment using the following variables (via `terraform.tfvars` or environment variables):

| Name                          | Description                                 | Default                      |
|-------------------------------|---------------------------------------------|------------------------------|
| `subscription_id`             | Azure Subscription ID                       | `"subscription_ID"`          |
| `resource_group_name`         | Resource Group name                         | `"HandsOn"`                  |
| `location`                    | Azure Region                                | `"francecentral"`            |
| `sku`                         | Databricks SKU                              | `"premium"`                  |
| `_environment`                | Environment tag                             | `"dev"`                      |
| `created_by`                  | Tag to identify resource creator            | `"Terraform"`                |
| `adb_workspace_name`          | Databricks workspace name                   | `"adb-fr-tribu-databricks"`  |
| `UnityCatalogStorageAccountName` | Name for Unity Catalog storage account | `"asaadbunitycatalog"`       |
| `metastoreStorageAccountName`   | Name for Metastore storage account     | `"asaadbmetastore"`          |

## 📦 Requirements

- Terraform >= 1.3.0
- Azure CLI authenticated session
- Permissions to create resources in your Azure subscription

## 🚀 Usage

```bash
# Initialize Terraform
terraform init

# Preview resources to be created
terraform plan

# Apply the configuration
terraform apply

## 🗑️ Clean Up
terraform destroy

👨‍💻 Author
Created by: Fernando MANTILLA with Terraform  
```

## 📂 File Descriptions

### `variables.tf`
This file contains the variable definitions for the Terraform configuration. It defines the variables used in the configuration, including their types, descriptions, and default values. These variables control various parameters for deploying the Azure Databricks workspace and associated resources.

Example of `variables.tf`:
```hcl 
# variables.tf

variable "subscription" {
  description = "The Azure subscription ID"
  type        = any 
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "HandsOn"  
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
```

### `main.tf`

This Terraform script creates an Azure Databricks workspace and two Azure Storage Accounts for Unity Catalog and Metastore. It uses the `azurerm` provider to manage Azure resources. The configuration includes decoding the `subscription.json` file and using the subscription data to configure the Azure provider.

Example of `main.tf`:

```hcl
# main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

# Decode the JSON file
locals {
  subscription_data = jsondecode(file("${path.module}/subscription.json"))
}

provider "azurerm" {
  features {}

  # Usar el ID de suscripción del archivo JSON
  subscription_id = local.subscription_data.subscriptionId
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
  name                         = var.adb_workspace_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  sku                          = var.sku
  managed_resource_group_name  = "${var.resource_group_name}-infra"

  tags =  {
    environment = var._environment
    created_by  = var.created_by
  }
}

# Create Azure Storage Account for Unity Catalog DataLake
resource "azurerm_storage_account" "uc" {
  name                         = var.UnityCatalogStorageAccountName
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_kind                 = "StorageV2" # Required for Unity Catalog
  account_replication_type     = "LRS"
  min_tls_version              = "TLS1_2"
  
  is_hns_enabled               = true

  tags = {
    environment = var._environment
    created_by  = var.created_by
  }
}

# Create Azure Storage Account for Metastore
resource "azurerm_storage_account" "metastore" {
  name                         = var.metastoreStorageAccountName
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type     = "LRS"
  min_tls_version              = "TLS1_2"

  tags = {
    environment = var._environment
    created_by  = var.created_by
  }
}

```

### `subscription.json`

This file contains the Azure credentials required for authentication, including the subscription ID, tenant ID, client ID, and client secret. It is used in `main.tf` to configure the Azure provider.

Example of subscription.json:

```json
{
    "id": "your-subscription-id",
    "tenantId": "your-tenant-id",
    "subscriptionId": "your-subscription-id",
    "clientId": "your-client-id",
    "clientSecret": "your-client-secret"
}
```

## 📖 Explanation of `subscription.json` Reading

In this Terraform project, we read the `subscription.json` file to retrieve the Azure credentials required to authenticate the provider. The file contains the subscription ID, tenant ID, client ID, and client secret, which are essential for connecting Terraform to Azure resources.

### How the JSON is Read in Terraform

#### 1. Decoding the JSON File:

In the `main.tf` file, we use the `jsondecode()` function to parse the contents of the `subscription.json` file. The `file()` function is used to read the file into a string, and `jsondecode()` converts that string into a structured map that can be used in Terraform.

```hcl
locals {
  subscription_data = jsondecode(file("${path.module}/subscription.json"))
}
```

Here, `local.subscription_data` will hold the parsed data from `subscription.json`.

#### 2. Using the Data in the Provider:

The `subscription_id` for the `azurerm` provider is then configured using the `subscriptionId` from the decoded JSON data:

```hcl
provider "azurerm" {
  features {}

  subscription_id = local.subscription_data.subscriptionId
}
````

This allows Terraform to authenticate to Azure using the correct subscription credentials from the JSON file.

## 🔐 Security Note

Please ensure that your `subscription.json` file containing sensitive data such as client secrets is not committed to version control (e.g., Git). Add it to `.gitignore` or use environment variables for sensitive data.

```bash
# .gitignore
subscription.json
```