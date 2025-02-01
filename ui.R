ui <- f7Page(
  title = "库存管理系统（移动端）",  # 更新页面标题
  options = list(dark = FALSE),
  
  f7SingleLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",  # 更新导航栏标题
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 搜索框
    f7Block(
      strong = TRUE,
      inset = TRUE,
      f7Text(inputId = "search_sku", label = "SKU / 物品名", placeholder = "输入 SKU 或 物品名..."),
      f7Button(inputId = "search_btn", label = "查询", color = "blue")
    ),
    
    # 物品信息显示
    uiOutput("item_info"),
    
    # 库存状态图表
    f7Block(
      f7BlockTitle(title = "库存状态分布", size = "large"),
      plotlyOutput("stock_distribution", height = "250px")
    )
  )
)
