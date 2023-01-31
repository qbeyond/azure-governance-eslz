terraform {
  required_providers {
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
