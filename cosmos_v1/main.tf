terraform {
  required_version = "1.7.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.93.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tatsukoni-test-v2"
    storage_account_name = "tfstatetatsukoniv1"
    container_name       = "tfstate"
    key                  = "cosmos_v1.tfstate"
  }
}

provider "azurerm" {
  features {}
}
