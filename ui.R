f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 整体布局
  f7SingleLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 固定搜索框
    div(
      style = "position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc;",
      f7Block(
        strong = FALSE,
        inset = FALSE,
        style = "margin: 0; padding: 0;",
        
        div(
          style = "display: flex; align-items: center; justify-content: space-between;",
          
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
      )
    ),
    
    # 可滚动搜索结果区域
    div(
      style = "margin-top: 80px; padding: 10px; overflow-y: auto; height: calc(100vh - 100px);",
      uiOutput("search_results")
    )
  )
)
