ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 采用 f7TabLayout，带有底部导航栏
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 主要功能页面
    f7Tabs(
      swipeable = FALSE,
      animated = TRUE,
      
      # 商品搜索
      f7Tab(
        tabName = "商品搜索",
        icon = f7Icon("search"),
        
        # 固定搜索框
        div(
          style = "position: fixed; top: 50px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc; display: flex; align-items: center; gap: 10px;",
          
          div(
            style = "flex: 1; min-width: 0;",  # 确保输入框按比例缩放
            f7Text(
              inputId = "search_sku",
              label = "商品搜索",
              placeholder = "输入 SKU / 物品名..."
            )
          )
        ),
        
        # 搜索结果区域，避免遮挡
        div(
          style = "padding-top: 70px; padding-bottom: 60px; overflow-y: auto; max-height: calc(100vh - 120px);",
          uiOutput("search_results")
        )
      ),
      
      # 其他功能（示例）
      f7Tab(
        tabName = "订单查询",
        icon = f7Icon("cart"),
        f7BlockTitle("订单查询"),
        f7Block(
          strong = TRUE,
          inset = TRUE,
          "这里是订单管理页面"
        )
      )
    )
  )
)
