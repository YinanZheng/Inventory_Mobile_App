server <- function(input, output, session) {
  con <- db_connection()  # 从 global.R 连接数据库
  
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
      return()
    }
    
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
    
    # 渲染库存状态图表（显示具体库存数量，不显示百分比 & legend）
    output$stock_distribution <- renderPlotly({
      plot_ly(
        labels = c("国内库存", "在途", "美国库存"),
        values = c(result$domestic_stock[1], result$transit_stock[1], result$us_stock[1]),
        type = "pie",
        hole = 0.4,  # 环形图
        textinfo = "label+value",  # 显示类别+数量（不显示百分比）
        marker = list(colors = c("#007BFF", "#FFC107", "#28A745")),
        showlegend = FALSE  # 关闭图例
      ) %>%
        layout(title = list(text = "库存状态（单位: 件）", font = list(size = 18)))
    })
  })
}
