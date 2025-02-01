ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  f7SingleLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 搜索框
    f7Block(
      strong = FALSE,
      inset = FALSE,
      style = "padding: 0; margin: 0;",
      
      div(
        style = "display: flex; align-items: center; justify-content: space-between; padding: 5px 10px;",
        
        # 输入框
        div(
          style = "flex: 2; margin-right: 10px; border: 1px solid #ccc; border-radius: 4px; padding: 5px; background-color: #fff;",
          f7Text(
            inputId = "search_sku",
            label = NULL,
            placeholder = "输入 SKU 或 物品名..."
          )
        ),
        
        # 查询按钮
        div(
          style = "flex: 1;",
          f7Button(
            inputId = "search_btn",
            label = "查询",
            color = "blue",
            fill = TRUE
          )
        )
      )
    ),
    
    # 搜索结果列表
    uiOutput("search_results")
  )
)
