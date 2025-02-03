library(shiny)
library(shinyMobile)
library(DBI)
library(RMariaDB)
library(plotly)

db_connection <- function() {
  dbConnect(
    RMariaDB::MariaDB(),
    dbname = "inventory_system",
    host = "localhost",
    user = "root",
    password = "goldenbeanllc",
    encoding = "utf8mb4"
  )
}

# 主机URL
host_url <<- "https://www.goldenbeanllc.com/"

# 通用物品表的列名
placeholder_300px_path <<- "https://dummyimage.com/300x300/cccccc/000000.png&text=No+Image"
placeholder_150px_path <<- "https://dummyimage.com/150x150/cccccc/000000.png&text=No+Image"
placeholder_50px_path <<- "https://dummyimage.com/50x50/cccccc/000000.png&text=No+Image"
