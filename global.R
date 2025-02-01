library(shiny)
library(shinyMobile)
library(DBI)
library(RMariaDB)

source("/srv/shiny-server/inventory_shared_module/utils.R", local = FALSE)  # 确保加载到全局环境

# 主机URL
host_url <<- "http://54.254.120.88/"

# 通用物品表的列名
placeholder_300px_path <<- "https://dummyimage.com/300x300/cccccc/000000.png&text=No+Image"
placeholder_150px_path <<- "https://dummyimage.com/150x150/cccccc/000000.png&text=No+Image"
placeholder_50px_path <<- "https://dummyimage.com/50x50/cccccc/000000.png&text=No+Image"
