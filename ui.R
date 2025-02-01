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
      strong = TRUE,
      inset = TRUE,
      div(
        style = "border: 1px solid #ccc; border-radius: 8px; padding: 10px; background-color: #fff;",
        f7Text(
          inputId = "search_sku",
          label = NULL,
          placeholder = "输入 SKU 或 物品名..."
        )
      ),
      div(
        style = "margin-top: 10px; text-align: center;",
        div(
          style = "width: 100%; max-width: 300px; margin: 0 auto;",  # 限制按钮宽度，不会太大
          f7Button(
            inputId = "search_btn",
            label = "查询",
            color = "blue",
            fill = TRUE  # 让按钮充满父容器
          )
        )
      )
    ),
    
    # 搜索结果列表
    uiOutput("search_results")
  )
)
