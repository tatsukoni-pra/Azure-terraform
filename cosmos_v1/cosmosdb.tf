resource "azurerm_cosmosdb_account" "cosmosdb_tatsukoni_test_v2" {
  name                  = "cosmosdb-tatsukoni-test-v2"
  location              = "Japan East"
  resource_group_name   = data.azurerm_resource_group.tatsukoni_test_v2.name
  default_identity_type = "FirstPartyIdentity"
  offer_type            = "Standard"
  kind                  = "GlobalDocumentDB"

  tags = {
    defaultExperience       = "Core (SQL)"
    Name                    = "cosmosdb-tatsukoni-test-v2"
    hidden-cosmos-mmspecial = ""
  }

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = "Japan East"
    failover_priority = 0
  }
}

###############################################################
# コンテナー単位でプロビジョニング済みスループット/TTLを割り当てるデモ実装
###############################################################
resource "azurerm_cosmosdb_sql_database" "tatsukoni_test_v3" {
  name                = "TatsukoniTestV3"
  resource_group_name = data.azurerm_resource_group.tatsukoni_test_v2.name
  account_name        = azurerm_cosmosdb_account.cosmosdb_tatsukoni_test_v2.name
}

resource "azurerm_cosmosdb_sql_container" "demo_container_1" {
  name                  = "DemoContainer1"
  resource_group_name   = data.azurerm_resource_group.tatsukoni_test_v2.name
  account_name          = azurerm_cosmosdb_account.cosmosdb_tatsukoni_test_v2.name
  database_name         = azurerm_cosmosdb_sql_database.tatsukoni_test_v3.name
  partition_key_path    = "/id"
  partition_key_version = 2
  default_ttl           = 3600

  conflict_resolution_policy {
    conflict_resolution_path = "/_ts"
    mode                     = "LastWriterWins"
  }

  autoscale_settings {
    max_throughput = 1000
  }
}

resource "azurerm_cosmosdb_sql_container" "demo_container_2" {
  name                  = "DemoContainer2"
  resource_group_name   = data.azurerm_resource_group.tatsukoni_test_v2.name
  account_name          = azurerm_cosmosdb_account.cosmosdb_tatsukoni_test_v2.name
  database_name         = azurerm_cosmosdb_sql_database.tatsukoni_test_v3.name
  partition_key_path    = "/id"
  partition_key_version = 2
  default_ttl           = 7200

  conflict_resolution_policy {
    conflict_resolution_path = "/_ts"
    mode                     = "LastWriterWins"
  }

  autoscale_settings {
    max_throughput = 2000
  }
}
