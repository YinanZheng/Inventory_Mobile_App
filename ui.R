ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  f7SingleLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE,
      style = "padding: 5px; margin: 0;"  # 减小标题栏的空白
    ),
    
    # 固定搜索框
    div(
      style = "position: fixed; top: 50px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px 10px 5px; border-bottom: 1px solid #ccc;",  # 增加顶部间距
      f7Block(
        strong = FALSE,  # 不需要强调样式
        inset = FALSE,  # 不嵌入边距
        style = "padding: 0; margin: 0;",  # 移除默认内外边距
        
        div(
          style = "display: flex; align-items: center; justify-content: space-between;",
          
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
      )
    ),
    
    # 可滚动搜索结果
    div(
      style = "margin-top: 120px; padding: 10px; overflow-y: auto; height: calc(100vh - 130px);",  # 增加 margin-top 确保不遮挡
      uiOutput("search_results")
    )
  )
)
