server <- function(input, output, session) {
  con <- db_connection()  # 连接数据库
  
  observeEvent(input$search_btn, {
    req(input$search_sku)
    
    search_query <- trimws(input$search_sku)
    
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
      showNotification("未找到相关库存", type = "warning")
      output$search_results <- renderUI(NULL)
      return()
    }
    
    # **确保 Status 是字符型**
    result$Status <- as.character(result$Status)
    
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
    output$search_results <- renderUI({
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
          style = "border: 1px solid #ccc; border-radius: 10px; margin-bottom: 15px; padding: 10px; background-color: #fff;",
          
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
}
