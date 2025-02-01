server <- function(input, output, session) {
  con <- db_connection()
  
  # 物品搜索逻辑
  observeEvent(input$search_item, {
    req(input$search_sku != "" | input$search_name != "")
    
    # 查询库存信息
    query <- paste0("
      SELECT SKU, ItemName, Maker, MajorType, MinorType, ProductCost, ShippingCost, Quantity, ItemImagePath
      FROM inventory
      WHERE SKU = '", input$search_sku, "'
         OR ItemName LIKE '%", input$search_name, "%'
    ")
    sku_data <- dbGetQuery(con, query)
    
    if (nrow(sku_data) == 0) {
      output$query_item_info <- renderUI({
        tags$p("未找到该物品", style = "color: red;")
      })
      output$inventory_status_chart <- renderPlotly({ NULL })
      return()
    }
    
    # 渲染物品详细信息
    output$query_item_info <- renderUI({
      # 根据是否有图片设置路径
      img_path <- ifelse(
        is.na(sku_data$ItemImagePath[1]),
        placeholder_150px_path,
        paste0(host_url, "/images/", basename(sku_data$ItemImagePath[1]))
      )
      
      # 计算库存统计信息，确保 unique_items_data() 已定义且返回包含 Status 字段的数据
      sku_stats <- unique_items_data() %>%
        filter(SKU == input$search_sku) %>%
        summarise(
          美国库存数 = sum(Status == "美国入库", na.rm = TRUE),
          在途库存数 = sum(Status == "国内出库", na.rm = TRUE),
          国内库存数 = sum(Status == "国内入库", na.rm = TRUE),
          已售库存数 = sum(Status %in% c("国内售出", "美国调货", "美国发货"), na.rm = TRUE)
        )
      
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
            tags$tr(tags$td(tags$b("商品名称：")), tags$td(sku_data$ItemName[1])),
            tags$tr(tags$td(tags$b("供应商：")), tags$td(sku_data$Maker[1])),
            tags$tr(tags$td(tags$b("分类：")), tags$td(paste(sku_data$MajorType[1], "/", sku_data$MinorType[1]))),
            tags$tr(tags$td(tags$b("平均成本：")), tags$td(sprintf("¥%.2f", sku_data$ProductCost[1]))),
            tags$tr(tags$td(tags$b("平均运费：")), tags$td(sprintf("¥%.2f", sku_data$ShippingCost[1]))),
            tags$tr(tags$td(tags$b("国内库存数：")), tags$td(sku_stats$国内库存数)),
            tags$tr(tags$td(tags$b("在途库存数：")), tags$td(sku_stats$在途库存数)),
            tags$tr(tags$td(tags$b("美国库存数：")), tags$td(sku_stats$美国库存数)),
            tags$tr(tags$td(tags$b("已售库存数：")), tags$td(sku_stats$已售库存数)),
            tags$tr(tags$td(tags$b("总库存数：")), tags$td(sku_data$Quantity[1]))
          )
        )
      )
    })
    
    # 渲染库存状态图表
    output$inventory_status_chart <- renderPlotly({
      tryCatch({
        data <- unique_items_data()
        
        if (is.null(input$search_sku) || trimws(input$search_sku) == "") {
          return(NULL)
        }
        
        # 筛选符合条件的数据
        inventory_status_data <- data %>%
          filter(SKU == trimws(input$search_sku)) %>%
          group_by(Status) %>%
          summarise(Count = n(), .groups = "drop")
        
        # 定义固定类别顺序和颜色
        status_levels <- c("采购", "国内入库", "国内售出", "国内出库", "美国入库", "美国调货", "美国发货", "退货")
        status_colors <- c("lightgray", "#c7e89b", "#9ca695", "#46a80d", "#6f52ff", "#529aff", "#faf0d4", "red")
        
        # 补全缺失的类别，并按照 status_levels 排序
        inventory_status_data <- merge(
          data.frame(Status = status_levels),
          inventory_status_data,
          by = "Status",
          all.x = TRUE
        )
        inventory_status_data$Count[is.na(inventory_status_data$Count)] <- 0
        inventory_status_data <- inventory_status_data[match(status_levels, inventory_status_data$Status), ]
        
        if (sum(inventory_status_data$Count) == 0) {
          plot_ly(type = "pie", labels = c("无数据"), values = c(1), textinfo = "label+value")
        } else {
          plot_ly(
            data = inventory_status_data,
            labels = ~Status,
            values = ~Count,
            type = "pie",
            textinfo = "label+value",
            hoverinfo = "label+percent+value",
            insidetextorientation = "auto",
            textposition = "inside",
            marker = list(colors = status_colors)
          ) %>%
            layout(
              showlegend = FALSE,
              margin = list(l = 20, r = 20, t = 30, b = 30),
              uniformtext = list(minsize = 10, mode = "hide")
            )
        }
      }, error = function(e) {
        showNotification(paste("库存状态图表生成错误：", e$message), type = "error")
        NULL
      })
    })
    
  })
  
  # 订单搜索逻辑（如有需要，可在此补充）
  
}
