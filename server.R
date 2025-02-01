server <- function(input, output, session) {
  
  source("global.R", local = TRUE)
  
  # Database
  con <- db_connection()
  
  # 绑定摄像头扫码事件
  observeEvent(input$scan_sku, { session$sendCustomMessage("startScanner", "search_sku") })
  observeEvent(input$scan_order_id, { session$sendCustomMessage("startScanner", "search_order_id") })
  
  # 物品搜索逻辑（SKU 或 物品名二选一）
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "") # 允许二选一
    
    query <- paste0("
      SELECT i.SKU, i.ItemName, i.Maker, i.MajorType, i.MinorType, i.ProductCost, i.ShippingCost, i.ItemImagePath, 
             u.Status, u.Defect, u.DefectNotes
      FROM inventory i
      LEFT JOIN unique_items u ON i.SKU = u.SKU
      WHERE i.SKU = '", input$search_sku, "' 
         OR i.ItemName LIKE '%", input$search_name, "%'
    ")
    
    result <- dbGetQuery(con, query)
    
    output$item_result <- renderUI({
      if (nrow(result) == 0) {
        return(tags$p("未找到该物品", style = "color: red;"))
      }
      
      # 处理图片路径
      item_img_path <- ifelse(
        is.na(result$ItemImagePath[1]) || result$ItemImagePath[1] == "",
        placeholder_150px_path,
        paste0(host_url, "/images/", basename(result$ItemImagePath[1]))
      )
      
      # 处理瑕疵情况
      defect_info <- paste(
        "瑕疵情况:", result$Defect[1], 
        ifelse(is.na(result$DefectNotes[1]) || result$DefectNotes[1] == "", "（无备注）", paste0("（", result$DefectNotes[1], "）"))
      )
      
      tagList(
        tags$h3("物品信息"),
        tags$img(src = item_img_path, width = "100%"),
        tags$p(paste("名称:", result$ItemName[1])),
        tags$p(paste("品牌:", result$Maker[1])),
        tags$p(paste("分类:", result$MajorType[1], "/", result$MinorType[1])),
        tags$p(paste("价格:", result$ProductCost[1], "元")),
        tags$p(paste("库存状态:", result$Status[1])),
        tags$p(defect_info)  # 使用修改后的瑕疵显示格式
      )
    })
  })
  
  # 订单搜索逻辑（订单号 或 运单号二选一）
  observeEvent(input$search_order, {
    req(input$search_order_id != "" | input$search_tracking != "") # 允许二选一
    
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
      
      # 处理订单图片路径
      order_img_path <- ifelse(
        is.na(result$OrderImagePath[1]) || result$OrderImagePath[1] == "",
        placeholder_150px_path,
        paste0(host_url, "/images/", basename(result$OrderImagePath[1]))
      )
      
      tagList(
        tags$h3("订单信息"),
        tags$img(src = order_img_path, width = "100%"),
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
