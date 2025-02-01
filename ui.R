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
      swipeable = TRUE,
      animated = FALSE,
      
      # 商品搜索
      f7Tab(
        tabName = "商品搜索",
        icon = f7Icon("search"),
        
        # 固定搜索框
        div(
          style = "position: fixed; top: 40px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc;",
          f7BlockTitle("商品搜索"),
          f7Block(
            strong = FALSE,
            inset = FALSE,
            style = "padding: 0; margin: 0;",
            
            div(
              style = "display: flex; align-items: center; justify-content: space-between;",
              
              div(
                style = "flex: 2; margin-right: 10px;",
                f7Text(
                  inputId = "search_sku",
                  label = NULL,
                  placeholder = "输入 SKU 或 物品名..."
                )
              ),
              
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
        
        # 搜索结果区域
        div(
          style = "margin-top: 120px; padding: 10px; overflow-y: auto; height: calc(100vh - 130px);",
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
    ),
    
    # **底部导航栏**
    f7Toolbar(
      position = "bottom",
      icons = TRUE,
      f7Link(tab = "物品搜索", icon = f7Icon("search"), label = "商品"),
      f7Link(tab = "订单查询", icon = f7Icon("cart"), label = "订单"),
    )
  )
)
