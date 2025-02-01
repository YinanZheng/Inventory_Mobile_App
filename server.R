server <- function(input, output, session) {
  con <- db_connection()  # 连接数据库
  
  observeEvent(input$search_btn, {
    req(input$search_sku)
    
    search_query <- trimws(input$search_sku)
    
    query <- paste0("
      SELECT 
        i.SKU, i.ItemName, i.Maker, i.MajorType, i.MinorType, 
        i.ProductCost, i.ShippingCost, i.ItemImagePath,
        SUM(CASE WHEN u.Status = '国内入库' THEN 1 ELSE 0 END) AS domestic_stock,
        SUM(CASE WHEN u.Status = '在途' THEN 1 ELSE 0 END) AS transit_stock,
        SUM(CASE WHEN u.Status = '美国入库' THEN 1 ELSE 0 END) AS us_stock,
        COUNT(*) AS total_stock
      FROM inventory i
      LEFT JOIN unique_items u ON i.SKU = u.SKU
      WHERE i.SKU = '", search_query, "' OR i.ItemName LIKE '%", search_query, "%'
      GROUP BY i.SKU
    ")
    
    result <- dbGetQuery(con, query)
    
    if (nrow(result) == 0) {
      showNotification("未找到相关库存", type = "warning")
      output$item_info <- renderUI(NULL)
      output$stock_table_ui <- renderUI(NULL)
      return()
    }
    
    # 渲染物品信息
    output$item_info <- renderUI({
      item <- result[1, ]
      
      img_path <- ifelse(
        is.na(item$ItemImagePath) || item$ItemImagePath == "",
        placeholder_300px_path,
        paste0(host_url, "/images/", basename(item$ItemImagePath))
      )
      
      f7Card(
        title = item$ItemName,
        f7Block(
          f7BlockHeader(text = paste("SKU:", item$SKU)),
          f7BlockFooter(text = paste("供应商:", item$Maker)),
          div(style = "text-align: center;", tags$img(src = img_path, style = "max-width: 100%; height: auto; border-radius: 10px;")),
          f7BlockFooter(text = paste("分类:", item$MajorType, "/", item$MinorType)),
          f7BlockFooter(text = paste("单价: ¥", item$ProductCost, " | 运费: ¥", item$ShippingCost))
        )
      )
    })
    
    # 渲染库存状态表
    output$stock_table_ui <- renderUI({
      f7Block(
        f7BlockTitle(title = "库存状态", size = "large"),  # 仅在有数据时显示
        div(
          style = "overflow-x: auto;",
          tags$table(
            style = "width: 100%; border-collapse: collapse; text-align: left;",
            tags$thead(
              tags$tr(
                tags$th(style = "border-bottom: 2px solid #ccc; padding: 10px;", "库存类型"),
                tags$th(style = "border-bottom: 2px solid #ccc; padding: 10px;", "数量")
              )
            ),
            tags$tbody(
              tags$tr(
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", "国内库存"),
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", result$domestic_stock[1])
              ),
              tags$tr(
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", "在途"),
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", result$transit_stock[1])
              ),
              tags$tr(
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", "美国库存"),
                tags$td(style = "padding: 10px; border-bottom: 1px solid #eee;", result$us_stock[1])
              ),
              tags$tr(
                tags$td(style = "padding: 10px; font-weight: bold;", "总库存"),
                tags$td(style = "padding: 10px; font-weight: bold;", result$total_stock[1])
              )
            )
          )
        )
      )
    })
  })
}
