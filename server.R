server <- function(input, output, session) {
  source("global.R", local = TRUE)
  
  # 获取数据库连接（请确保 global.R 中 db_connection() 正常工作）
  con <- db_connection()
  
  # 物品搜索逻辑
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "")
    
    sku <- input$search_sku
    query <- paste0("
      SELECT i.SKU, i.ItemName, i.Maker, i.MajorType, i.MinorType, i.ProductCost, i.ShippingCost, i.Quantity, i.ItemImagePath
      FROM inventory i
      WHERE i.SKU = '", sku, "' 
         OR i.ItemName LIKE '%", input$search_name, "%'
    ")
    
    sku_data <- dbGetQuery(con, query)
    if (nrow(sku_data) == 0) {
      output$item_result <- renderUI(
        tags$p("未找到该物品", style = "color: red;")
      )
      return()
    }
    
    img_path <- ifelse(
      is.na(sku_data$ItemImagePath[1]),
      placeholder_150px_path,
      paste0(host_url, "/images/", basename(sku_data$ItemImagePath[1]))
    )
    
    output$item_result <- renderUI({
      div(
        style = "display: flex; flex-direction: column; align-items: center; padding: 10px;",
        div(
          style = "text-align: center; margin-bottom: 10px;",
          tags$img(src = img_path, height = "150px", style = "border: 1px solid #ddd; border-radius: 8px;")
        ),
        div(
          style = "width: 100%; padding-left: 10px;",
          tags$table(
            style = "width: 100%; border-collapse: collapse;",
            tags$tr(
              tags$td(tags$b("商品名称：")),
              tags$td(sku_data$ItemName[1])
            ),
            tags$tr(
              tags$td(tags$b("供应商：")),
              tags$td(sku_data$Maker[1])
            ),
            tags$tr(
              tags$td(tags$b("分类：")),
              tags$td(paste(sku_data$MajorType[1], "/", sku_data$MinorType[1]))
            ),
            tags$tr(
              tags$td(tags$b("平均成本：")),
              tags$td(sprintf("¥%.2f", sku_data$ProductCost[1]))
            ),
            tags$tr(
              tags$td(tags$b("平均运费：")),
              tags$td(sprintf("¥%.2f", sku_data$ShippingCost[1]))
            ),
            tags$tr(
              tags$td(tags$b("库存总数：")),
              tags$td(sku_data$Quantity[1])
            )
          )
        )
      )
    })
  })
  
  # 订单搜索逻辑
  observeEvent(input$search_order, {
    req(input$search_order_id != "" | input$search_tracking != "")
    
    query <- paste0("
      SELECT OrderID, UsTrackingNumber, CustomerName, Platform, OrderImagePath, OrderNotes, OrderStatus
      FROM orders
      WHERE OrderID = '", input$search_order_id, "' 
         OR UsTrackingNumber = '", input$search_tracking, "'
    ")
    
    result <- tryCatch({
      dbGetQuery(con, query)
    }, error = function(e) {
      showNotification("订单查询失败，请检查数据库！", type = "error")
      return(NULL)
    })
    
    if (is.null(result) || nrow(result) == 0) {
      output$order_result <- renderUI(
        tags$p("未找到该订单", style = "color: red;")
      )
      return()
    }
    
    output$order_result <- renderUI({
      tagList(
        lapply(1:nrow(result), function(i) {
          order_img_path <- ifelse(
            is.na(result$OrderImagePath[i]) || result$OrderImagePath[i] == "",
            placeholder_150px_path,
            paste0(host_url, "/images/", basename(result$OrderImagePath[i]))
          )
          
          f7Card(
            title = paste("订单号:", result$OrderID[i]),
            f7Block(
              f7Row(
                f7Col(
                  width = 4, 
                  tags$img(src = order_img_path, width = "100%")
                ),  
                f7Col(
                  width = 8, 
                  tags$p(paste("物流单号:", result$UsTrackingNumber[i])),
                  tags$p(paste("顾客:", result$CustomerName[i])),
                  tags$p(paste("平台:", result$Platform[i])),
                  tags$p(paste("状态:", result$OrderStatus[i])),
                  tags$p(paste("备注:", ifelse(is.na(result$OrderNotes[i]) || result$OrderNotes[i] == "", "无", result$OrderNotes[i])))
                )
              )
            )
          )
        })
      )
    })
  })
}
