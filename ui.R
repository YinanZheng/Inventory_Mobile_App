ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 采用 f7TabLayout，带有底部导航栏
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
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
        
        # 全局样式优化
        tags$style(HTML("
          /* 移除输入框外层多余的边距 */
          .list {
            margin: 0 !important;
            padding: 10px !important;
        ")),
        
        # 页面标题
        div(
          style = "
            position: fixed; 
            top: 42px;  /* 向下移动，留出顶部空间 */
            left: 10px; 
            right: 10px; 
            z-index: 1000; 
            text-align: center; 
            font-size: 20px; 
            font-weight: bold; 
            color: white; 
            background: #7598ff; 
            border-radius: 8px; 
            margin: 5px;
            padding: 5px; 
            line-height: 1.5;
          ",
          "商品库存查询"
        ),
        
        # 固定搜索框
        div(
          style = "position: fixed; top: 88px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 5px 5px; border-bottom: 1px solid #ccc; display: flex; align-items: stretch;",
          div(
            style = "flex: 1; min-width: 0;",
            f7Text(
              inputId = "search_sku",
              label = NULL,
              placeholder = "输入 SKU / 物品名..."
            )
          )
        ),
        
        # 占位符，避免内容被搜索框遮挡
        div(style = "height: 100px;"),
        
        # 让整个页面滚动，而不是搜索结果区域
        div(
          style = "min-height: 100vh; padding-bottom: 60px;",
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
