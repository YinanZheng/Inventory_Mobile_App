server <- function(input, output, session) {
  con <- db_connection()  # 连接数据库
  
  # 防抖处理：用户输入后 500ms 才触发查询，减少数据库查询压力
  debounce_item_search <- reactiveVal("")
  debounce_order_search <- reactiveVal("")
  
  observe({
    invalidateLater(500, session)  # **防抖延迟 500ms**
    debounce_item_search(trimws(input$search_sku_item))
  })
  
  observe({
    invalidateLater(500, session)  # **防抖延迟 500ms**
    debounce_order_search(trimws(input$search_order_label))
  })
  
  observeEvent(input$scan_barcode_sku, {
    session$sendCustomMessage("startBarcodeScanner", "search_sku_item")
  })
  
  observeEvent(input$scan_barcode_order, {
    session$sendCustomMessage("startBarcodeScanner", "search_order_label")
  })
  
  # 监听 debounce_item_search 的变化，执行搜索
  observe({
    req(debounce_item_search())
    
    search_query <- debounce_item_search()
    
    query <- paste0("
      SELECT 
        i.SKU, i.ItemName, i.Maker, i.MajorType, i.MinorType, 
        i.ProductCost, i.ShippingCost, i.ItemImagePath,
        u.Status
      FROM inventory i
      LEFT JOIN unique_items u ON i.SKU = u.SKU
      WHERE i.SKU = '", search_query, "' OR i.ItemName LIKE '%", search_query, "%'
    ")
    
    result <- dbGetQuery(con, query)
    
    if (nrow(result) == 0) {
      return()
    }
    
    # **确保 Status 是字符型**
    result$Status <- as.character(result$Status)
    
    # **去重，确保每个 SKU 只显示一次**
    result <- distinct(result, SKU, .keep_all = TRUE)
    
    # **计算库存统计**
    stock_summary <- result %>%
      group_by(SKU) %>%  
      summarise(
        美国库存数 = sum(ifelse(Status == "美国入库", 1, 0), na.rm = TRUE),
        在途库存数 = sum(ifelse(Status == "国内出库", 1, 0), na.rm = TRUE),
        国内库存数 = sum(ifelse(Status == "国内入库", 1, 0), na.rm = TRUE),
        .groups = "drop"
      )
    
    # 渲染搜索结果
    output$item_search_results <- renderUI({
      lapply(1:nrow(result), function(i) {
        item <- result[i, ]
        stock <- stock_summary %>% filter(SKU == item$SKU)
        
        img_path <- ifelse(
          is.na(item$ItemImagePath) || item$ItemImagePath == "",
          placeholder_150px_path,  # **使用小图**
          paste0(host_url, "/images/", basename(item$ItemImagePath))
        )
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          style = "border: 1px solid #ccc; border-radius: 10px; margin-bottom: 10px; padding: 10px; background-color: #fff;",
          
          # 物品信息
          div(
            style = "display: flex; align-items: center;",
            div(
              style = "flex: 1; text-align: center;",
              tags$img(src = img_path, style = "max-width: 80px; height: auto; border-radius: 8px;")
            ),
            div(
              style = "flex: 3; padding-left: 10px;",
              tags$h4(item$ItemName, style = "margin: 5px 0; font-size: 16px; font-weight: bold;"),
              tags$p(paste("SKU:", item$SKU), style = "margin: 2px 0; font-size: 14px; color: #555;"),
              tags$p(paste("供应商:", item$Maker), style = "margin: 2px 0; font-size: 14px; color: #555;"),
              tags$p(paste("分类:", item$MajorType, "/", item$MinorType), style = "margin: 2px 0; font-size: 14px; color: #555;"),
              tags$p(paste("单价: ¥", item$ProductCost, " | 运费: ¥", item$ShippingCost), style = "margin: 2px 0; font-size: 14px; color: #333; font-weight: bold;")
            )
          ),
          
          # 库存状态
          div(
            style = "margin-top: 10px;",
            tags$table(
              style = "width: 100%; border-collapse: collapse; text-align: left;",
              tags$thead(
                tags$tr(
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "库存类型"),
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "数量")
                )
              ),
              tags$tbody(
                tags$tr(
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", "国内库存"),
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", stock$国内库存数)
                ),
                tags$tr(
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", "在途库存"),
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", stock$在途库存数)
                ),
                tags$tr(
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", "美国库存"),
                  tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", stock$美国库存数)
                ),
                tags$tr(
                  tags$td(style = "padding: 8px; font-weight: bold;", "总库存"),
                  tags$td(style = "padding: 8px; font-weight: bold;", 
                          sum(stock$美国库存数, stock$在途库存数, stock$国内库存数, na.rm = TRUE))  # ✅ **修正 sum()**
                )
              )
            )
          )
        )
      })
    })
  })
  
  
  # 监听 debounce_order_search 的变化，执行订单查询
  observe({
    req(debounce_order_search())
    search_query <- debounce_order_search()
    
    query <- paste0("
      SELECT 
        o.OrderID, o.UsTrackingNumber, o.CustomerName, o.CustomerNetName, 
        o.Platform, o.OrderImagePath, o.OrderNotes, o.OrderStatus, 
        u.SKU, u.Status, u.ProductCost, u.DomesticShippingCost, 
        i.ItemName, i.ItemImagePath  -- ✅ 修正图片字段，来自 inventory
      FROM orders o
      LEFT JOIN unique_items u ON o.OrderID = u.OrderID
      LEFT JOIN inventory i ON u.SKU = i.SKU  -- ✅ 关联 inventory 以获取商品信息
      WHERE o.OrderID = '", search_query, "' 
         OR o.UsTrackingNumber = '", search_query, "'
    ")
    
    result <- dbGetQuery(con, query)
    
    if (nrow(result) == 0) {
      showNotification("未找到相关订单", type = "warning")
      output$order_search_results <- renderUI(NULL)
      return()
    }
    
    # 确保 Status 是字符型
    result$Status <- as.character(result$Status)
    
    # 订单信息（去重）
    order_info <- result %>% distinct(OrderID, .keep_all = TRUE)
    
    # 渲染搜索结果
    output$order_search_results <- renderUI({
      lapply(1:nrow(order_info), function(i) {
        order <- order_info[i, ]
        
        # 订单图片路径
        order_img_path <- ifelse(
          is.na(order$OrderImagePath) || order$OrderImagePath == "",
          placeholder_150px_path,
          paste0(host_url, "/images/", basename(order$OrderImagePath))
        )
        
        # 订单商品信息
        order_items <- result %>% filter(OrderID == order$OrderID)
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          style = "border: 1px solid #ccc; border-radius: 10px; margin-bottom: 15px; padding: 10px; background-color: #fff;",
          
          # 订单基本信息
          div(
            style = "display: flex; align-items: center;",
            div(
              style = "flex: 1; text-align: center;",
              tags$img(src = order_img_path, style = "max-width: 100px; height: auto; border-radius: 8px;")
            ),
            div(
              style = "flex: 3; padding-left: 10px;",
              tags$h4(paste("订单号:", order$OrderID), style = "margin: 5px 0; font-size: 16px; font-weight: bold;"),
              tags$p(paste("运单号:", ifelse(is.na(order$UsTrackingNumber) || order$UsTrackingNumber == "", "无", order$UsTrackingNumber)),style = "margin: 2px 0; font-size: 12px; color: #555;"),
              tags$p(paste("客户:", order$CustomerName), style = "margin: 2px 0; font-size: 14px; color: #555;"),
              tags$p(paste("平台:", order$Platform), style = "margin: 2px 0; font-size: 14px; color: #555;"),
              tags$p(paste("状态:", order$OrderStatus),   style = "margin: 2px 0; font-size: 14px; font-weight: bold; color: #007aff;"),
              tags$p(paste("备注:", ifelse(is.na(order$OrderNotes) || order$OrderNotes == "", "无", order$OrderNotes)), style = "margin: 2px 0; font-size: 14px; color: #333; word-wrap: break-word; overflow-wrap: break-word; max-width: 100%;")
            )
          ),
          
          # 订单内商品列表
          div(
            style = "margin-top: 10px;",
            tags$table(
              style = "width: 100%; border-collapse: collapse; text-align: left;",
              tags$thead(
                tags$tr(
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "图片"),
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "SKU"),
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "名称"),
                  tags$th(style = "border-bottom: 2px solid #ccc; padding: 8px;", "状态")
                )
              ),
              tags$tbody(
                lapply(1:nrow(order_items), function(j) {
                  item <- order_items[j, ]
                  item_img_path <- ifelse(
                    is.na(item$ItemImagePath) || item$ItemImagePath == "",
                    placeholder_150px_path,
                    paste0(host_url, "/images/", basename(item$ItemImagePath))
                  )
                  
                  tags$tr(
                    tags$td(style = "padding: 8px; border-bottom: 1px solid #eee; text-align: center;", 
                            tags$img(src = item_img_path, style = "max-width: 50px; height: auto; border-radius: 5px;")),
                    tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", item$SKU),
                    tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", item$ItemName),
                    tags$td(style = "padding: 8px; border-bottom: 1px solid #eee;", item$Status)
                  )
                })
              )
            )
          )
        )
      })
    })
  })
  
  # Disconnect from the database on app stop
  onStop(function() {
    dbDisconnect(con)
  })
}
