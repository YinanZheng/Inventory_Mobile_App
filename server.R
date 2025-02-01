server <- function(input, output, session) {
  source("global.R", local = TRUE)
  
  # Database
  con <- db_connection()
  
  # 绑定摄像头扫码事件
  observeEvent(input$scan_sku, { session$sendCustomMessage("startScanner", "search_sku") })
  observeEvent(input$scan_order_id, { session$sendCustomMessage("startScanner", "search_order_id") })
  
  # 📦 物品搜索逻辑
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
    
    result <- tryCatch({
      dbGetQuery(con, query)
    }, error = function(e) {
      showNotification("查询失败，请检查数据库连接或查询条件！", type = "error")
      return(NULL)
    })
    
    if (is.null(result) || nrow(result) == 0) {
      output$item_result <- renderUI(tags$p("未找到该物品", style = "color: red;"))
      return()
    }
    
    output$item_result <- renderUI({
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
            f7Block(
              f7Row(
                f7Col(width = 4, 
                      tags$a(tags$img(src = item_img_path, width = "100%", onclick = paste0("openImage('", item_img_path, "')")))),  # ✅ 点击放大
                f7Col(width = 8, 
                      tags$p(paste("供应商:", result$Maker[i])),
                      tags$p(paste("分类:", result$MajorType[i], "/", result$MinorType[i])),
                      tags$p(paste("价格:", result$ProductCost[i], "元")),
                      tags$p(defect_info))
              )
            )
          )
        })
      )
    })
  })
  
  # 📜 订单搜索逻辑
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
      output$order_result <- renderUI(tags$p("未找到该订单", style = "color: red;"))
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
                f7Col(width = 4, 
                      tags$a(tags$img(src = order_img_path, width = "100%", onclick = paste0("openImage('", order_img_path, "')")))),  # ✅ 点击放大
                f7Col(width = 8, 
                      tags$p(paste("物流单号:", result$UsTrackingNumber[i])),
                      tags$p(paste("顾客:", result$CustomerName[i])),
                      tags$p(paste("平台:", result$Platform[i])),
                      tags$p(paste("状态:", result$OrderStatus[i])),
                      tags$p(paste("备注:", ifelse(is.na(result$OrderNotes[i]) || result$OrderNotes[i] == "", "无", result$OrderNotes[i]))))
              )
            )
          )
        })
      )
    })
  })
}
