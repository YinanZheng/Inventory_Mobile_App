server <- function(input, output, session) {
  con <- db_connection()  # 建立数据库连接
  
  unique_items_data <- reactive({
    dbGetQuery(con, "
    SELECT 
      unique_items.UniqueID, 
      unique_items.SKU, 
      unique_items.OrderID,
      unique_items.ProductCost,
      unique_items.DomesticShippingCost,
      unique_items.Status,
      unique_items.Defect,
      unique_items.DefectNotes,
      unique_items.IntlShippingMethod,
      unique_items.IntlTracking,
      unique_items.IntlShippingCost,
      unique_items.PurchaseTime,
      unique_items.DomesticEntryTime,
      unique_items.DomesticExitTime,
      unique_items.DomesticSoldTime,
      unique_items.UsEntryTime,
      unique_items.UsShippingTime,
      unique_items.UsRelocationTime,
      unique_items.ReturnTime,
      unique_items.PurchaseCheck,
      unique_items.updated_at,
      inventory.Maker,
      inventory.MajorType,
      inventory.MinorType,
      inventory.ItemName,
      inventory.ItemImagePath
    FROM 
      unique_items
    JOIN 
      inventory 
    ON 
      unique_items.SKU = inventory.SKU
    ORDER BY 
      unique_items.updated_at DESC
  ")
  })
  
  # 物品搜索逻辑
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "")
    
    # 查询库存信息
    query <- paste0(
      "SELECT SKU, ItemName, Maker, MajorType, MinorType, ProductCost, ShippingCost, Quantity, ItemImagePath FROM inventory ",
      "WHERE SKU = '", input$search_sku, "' OR ItemName LIKE '%", input$search_name, "%'"
    )
    sku_data <- dbGetQuery(con, query)
    
    if (nrow(sku_data) == 0) {
      output$query_item_info <- renderUI({
        tags$p("未找到该物品", style = "color: red;")
      })
      return()
    }
    
    # 渲染物品详细信息
    output$query_item_info <- renderUI({
      # 判断图片路径是否存在
      img_path <- ifelse(
        is.na(sku_data$ItemImagePath[1]),
        placeholder_150px_path,
        paste0(host_url, "/images/", basename(sku_data$ItemImagePath[1]))
      )
      
      # 利用 unique_items_data() 计算库存统计信息
      sku_stats <- unique_items_data() %>%
        filter(SKU == input$search_sku) %>%
        summarise(
          美国库存数 = sum(Status == "美国入库", na.rm = TRUE),
          在途库存数 = sum(Status == "国内出库", na.rm = TRUE),
          国内库存数 = sum(Status == "国内入库", na.rm = TRUE),
          已售库存数 = sum(Status %in% c("国内售出", "美国调货", "美国发货"), na.rm = TRUE)
        )
      
      div(
        style = "display: flex; flex-direction: column; align-items: center; padding: 10px;",
        div(
          style = "text-align: center; margin-bottom: 10px;",
          tags$img(src = img_path, height = "150px",
                   style = "border: 1px solid #ddd; border-radius: 8px;")
        ),
        div(
          style = "width: 100%; padding-left: 10px;",
          tags$table(
            style = "width: 100%; border-collapse: collapse;",
            tags$tr(
              tags$td(tags$b("商品名称：")), tags$td(sku_data$ItemName[1])
            ),
            tags$tr(
              tags$td(tags$b("供应商：")), tags$td(sku_data$Maker[1])
            ),
            tags$tr(
              tags$td(tags$b("分类：")), tags$td(paste(sku_data$MajorType[1], "/", sku_data$MinorType[1]))
            ),
            tags$tr(
              tags$td(tags$b("平均成本：")), tags$td(sprintf("¥%.2f", sku_data$ProductCost[1]))
            ),
            tags$tr(
              tags$td(tags$b("平均运费：")), tags$td(sprintf("¥%.2f", sku_data$ShippingCost[1]))
            ),
            tags$tr(
              tags$td(tags$b("国内库存数：")), tags$td(sku_stats$国内库存数)
            ),
            tags$tr(
              tags$td(tags$b("在途库存数：")), tags$td(sku_stats$在途库存数)
            ),
            tags$tr(
              tags$td(tags$b("美国库存数：")), tags$td(sku_stats$美国库存数)
            ),
            tags$tr(
              tags$td(tags$b("已售库存数：")), tags$td(sku_stats$已售库存数)
            ),
            tags$tr(
              tags$td(tags$b("总库存数：")), tags$td(sku_data$Quantity[1])
            )
          )
        )
      )
    })
  })
  
  # 订单搜索逻辑（根据需要补充）
  output$order_result <- renderUI({
    tags$p("订单搜索功能待实现。")
  })
}
