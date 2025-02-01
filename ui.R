ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 使用 f7TabLayout 构建带有底部导航栏的布局
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 使用 id = "tabs" 让 f7TabLink 控制 f7Tabs
    f7Tabs(
      id = "tabs",
      swipeable = FALSE,
      animated = TRUE,
      
      # 商品搜索 tab
      f7Tab(
        tabName = "商品搜索",
        icon = f7Icon("search"),
        active = TRUE,
        # 用 flex 布局构建整个页面区域，高度设为 100vh（全屏）
        div(
          style = "display: flex; flex-direction: column; height: 100vh; overflow: hidden;",
          
          # 搜索区域：固定在上方（不采用 fixed 定位，而是作为 flex 子元素）
          div(
            style = "padding: 10px; border-bottom: 1px solid #ccc;",
            f7BlockTitle("商品搜索"),
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
          ),
          
          # 搜索结果区域：设置 flex:1 填满剩余空间，且加上 bottom padding 避免内容覆盖底部工具栏
          div(
            style = "flex: 1; overflow-y: auto; padding: 10px; padding-bottom: 60px;",
            uiOutput("search_results")
          )
        )
      ),
      
      # 订单查询 tab
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
    
    # 底部导航栏（注意增加了 z-index，确保始终在最上层）
    f7Toolbar(
      position = "bottom",
      icons = TRUE,
      style = "z-index: 9999;",
      f7TabLink(tab = "商品搜索", icon = f7Icon("search"), label = "商品"),
      f7TabLink(tab = "订单查询", icon = f7Icon("cart"), label = "订单")
    )
  )
)