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
| `workspace_name`              | Databricks Workspace name                   | `"value"`                    |
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
Created by: Fernando MANTILLA • Terraform  
