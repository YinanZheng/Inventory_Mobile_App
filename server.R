
server <- function(input, output, session) {
  con <- db_connection()
  
  # 绑定摄像头扫码事件
  observeEvent(input$scan_sku, { session$sendCustomMessage("startScanner", "search_sku") })
  observeEvent(input$scan_order_id, { session$sendCustomMessage("startScanner", "search_order_id") })
  
  # 物品搜索逻辑
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "")
    
    query <- paste0("
      SELECT SKU, ItemName, Maker, MajorType, MinorType, ProductCost, ShippingCost, ItemImagePath
      FROM inventory
      WHERE SKU = '", input$search_sku, "' 
         OR ItemName LIKE '%", input$search_name, "%'
    ")
    
    result <- dbGetQuery(con, query)
    
    output$item_result <- renderUI({
      if (nrow(result) == 0) return(tags$p("未找到该物品", style = "color: red;"))
      
      item_img_path <- ifelse(
        is.na(result$ItemImagePath[1]) || result$ItemImagePath[1] == "",
        placeholder_150px_path,
        paste0(host_url, "/images/", basename(result$ItemImagePath[1]))
      )
      
      tagList(
        tags$h3("物品信息"),
        tags$img(src = item_img_path, width = "100%"),
        tags$p(paste("名称:", result$ItemName[1]))
      )
    })
  })
}
