# Creamos el grupo de recursos donde vamos a tener todos nuestros recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "data_storage" {
  name                     = "st${var.project}${var.environment}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "dataset_container" {
  name                  = "bs-${var.project}-${var.environment}"
  storage_account_id    = azurerm_storage_account.data_storage.id
  container_access_type = "private"
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-${var.project}-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.admin_sql_username
  administrator_login_password = var.admin_sql_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "sql_database" {
  name      = "db${var.project}${var.environment}"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0"
  tags      = var.tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_data_factory" "data_factory_etl" {
  name                = "adf-${var.project}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.project}${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "spapi" {
  name                = "asp-${var.project}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp-api" {
  name                = "app-${var.project}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.spapi.id

  site_config {
    always_on = true
    application_stack {
      docker_registry_url = "https://index.docker.io"
      docker_image_name   = "nginx:latest"
    }
  }

  app_settings = {
    PORT              = var.port
    DATABASE_TYPE     = var.db_type
    DATABASE_HOST     = var.db_host
    DATABASE_PORT     = var.db_port
    DATABASE_USERNAME = var.admin_sql_username
    DATABASE_PASSWORD = var.admin_sql_password
    DATABASE_NAME     = var.db_name
  }
}
