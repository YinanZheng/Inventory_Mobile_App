server <- function(input, output, session) {
  source("global.R", local = TRUE)
  
  # Database
  con <- db_connection()
  
  # 绑定摄像头扫码事件
  observeEvent(input$scan_sku, { session$sendCustomMessage("startScanner", "search_sku") })
  observeEvent(input$scan_order_id, { session$sendCustomMessage("startScanner", "search_order_id") })
  
  # 物品搜索逻辑（显示所有匹配的物品，并包含瑕疵信息）
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "")
    
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
      if (nrow(result) == 0) return(tags$p("未找到该物品", style = "color: red;"))
      
      tagList(
        lapply(1:nrow(result), function(i) {
          item_img_path <- ifelse(
            is.na(result$ItemImagePath[i]) || result$ItemImagePath[i] == "",
            placeholder_150px_path,
            paste0(host_url, "/images/", basename(result$ItemImagePath[i]))
          )
          
          defect_info <- paste(
            "瑕疵情况:", result$Defect[i], 
            ifelse(is.na(result$DefectNotes[i]) || result$DefectNotes[i] == "", "（无备注）", paste0("（", result$DefectNotes[i], "）"))
          )
          
          f7Card(
            title = result$ItemName[i],
            f7Img(src = item_img_path, width = "100%"),
            f7Text("供应商:", result$Maker[i]),
            f7Text("分类:", paste(result$MajorType[i], "/", result$MinorType[i])),
            f7Text("成本:", paste0(result$ProductCost[i], "元")),
            f7Text(defect_info)
          )
        })
      )
    })
  })
  
  # 订单搜索逻辑（显示所有符合条件的订单）
  observeEvent(input$search_order, {
    req(input$search_order_id != "" | input$search_tracking != "")
    
    query <- paste0("
      SELECT OrderID, UsTrackingNumber, CustomerName, Platform, OrderImagePath, OrderNotes, OrderStatus
      FROM orders
      WHERE OrderID = '", input$search_order_id, "' 
         OR UsTrackingNumber = '", input$search_tracking, "'
    ")
    
    result <- dbGetQuery(con, query)
    
    output$order_result <- renderUI({
      if (nrow(result) == 0) return(tags$p("未找到该订单", style = "color: red;"))
      
      tagList(
        lapply(1:nrow(result), function(i) {
          order_img_path <- ifelse(
            is.na(result$OrderImagePath[i]) || result$OrderImagePath[i] == "",
            placeholder_150px_path,
            paste0(host_url, "/images/", basename(result$OrderImagePath[i]))
          )
          
          f7Card(
            title = paste("订单号:", result$OrderID[i]),
            f7Img(src = order_img_path, width = "100%"),
            f7Text("物流单号:", result$UsTrackingNumber[i]),
            f7Text("顾客:", result$CustomerName[i]),
            f7Text("平台:", result$Platform[i]),
            f7Text("状态:", result$OrderStatus[i]),
            f7Text("备注:", ifelse(is.na(result$OrderNotes[i]) || result$OrderNotes[i] == "", "无", result$OrderNotes[i]))
          )
        })
      )
    })
  })
}
