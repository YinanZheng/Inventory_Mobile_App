server <- function(input, output, session) {
  
  # Database
  con <- db_connection()
  
  # 绑定摄像头扫码事件
  observeEvent(input$scan_sku, { session$sendCustomMessage("startScanner", "search_sku") })
  observeEvent(input$scan_order_id, { session$sendCustomMessage("startScanner", "search_order_id") })
  observeEvent(input$scan_tracking, { session$sendCustomMessage("startScanner", "search_tracking") })
  
  # 物品搜索逻辑
  observeEvent(input$search_item, {
    req(input$search_sku, input$search_name)
    
    # 构建查询语句
    query <- paste0("
      SELECT i.SKU, i.ItemName, i.Maker, i.MajorType, i.MinorType, i.ProductCost, i.ShippingCost, i.ItemImagePath, 
             u.Status, u.Defect, u.DefectNotes
      FROM inventory i
      LEFT JOIN unique_items u ON i.SKU = u.SKU
      WHERE i.SKU = '", input$search_sku, "' 
         OR i.ItemName LIKE '%", input$search_name, "%'
    ")
    
    # 获取查询结果
    result <- dbGetQuery(con, query)
    
    # 渲染 UI
    output$item_result <- renderUI({
      if (nrow(result) == 0) {
        return(tags$p("未找到该物品", style = "color: red;"))
      }
      
      tagList(
        tags$h3("物品信息"),
        tags$img(src = result$ItemImagePath[1], width = "100%"),
        tags$p(paste("名称:", result$ItemName[1])),
        tags$p(paste("品牌:", result$Maker[1])),
        tags$p(paste("分类:", result$MajorType[1], "/", result$MinorType[1])),
        tags$p(paste("价格:", result$ProductCost[1], "元")),
        tags$p(paste("库存状态:", result$Status[1])),
        tags$p(paste("瑕疵情况:", result$Defect[1], result$DefectNotes[1]))
      )
    })
  })
  
  # 订单搜索逻辑
  observeEvent(input$search_order, {
    req(input$search_order_id, input$search_tracking)
    
    # 查询订单
    query <- paste0("
      SELECT OrderID, UsTrackingNumber, CustomerName, Platform, OrderImagePath, OrderNotes, OrderStatus
      FROM orders
      WHERE OrderID = '", input$search_order_id, "' 
         OR UsTrackingNumber = '", input$search_tracking, "'
    ")
    
    result <- dbGetQuery(con, query)
    
    output$order_result <- renderUI({
      if (nrow(result) == 0) {
        return(tags$p("未找到该订单", style = "color: red;"))
      }
      
      tagList(
        tags$h3("订单信息"),
        tags$img(src = result$OrderImagePath[1], width = "100%"),
        tags$p(paste("订单号:", result$OrderID[1])),
        tags$p(paste("物流单号:", result$UsTrackingNumber[1])),
        tags$p(paste("顾客:", result$CustomerName[1])),
        tags$p(paste("平台:", result$Platform[1])),
        tags$p(paste("状态:", result$OrderStatus[1])),
        tags$p(paste("备注:", result$OrderNotes[1]))
      )
    })
  })
}
