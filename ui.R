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
      strong = FALSE,  # 不需要强调样式
      inset = FALSE,  # 不嵌入边距
      style = "padding: 0; margin: 0;",  # 移除默认内外边距
      
      div(
        style = "display: flex; align-items: center; justify-content: space-between; padding: 5px 10px;",
        
        # 输入框
        div(
          style = "flex: 2; margin-right: 10px;",  # 输入框占较大空间，右边留出间隙
          f7Text(
            inputId = "search_sku",
            label = NULL,
            placeholder = "输入 SKU 或 物品名..."
          )
        ),
        
        # 查询按钮
        div(
          style = "flex: 1;",  # 按钮占较小空间
          f7Button(
            inputId = "search_btn",
            label = "查询",
            color = "blue",
            fill = TRUE  # 按钮充满父容器
          )
        )
      )
    ),
    
    # 搜索结果列表
    uiOutput("search_results")
  )
)
