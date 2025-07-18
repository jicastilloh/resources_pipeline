provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Creamos el grupo de recursos donde vamos a tener todos nuestros recursos de la api_pipeline
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = var.tags
}
