ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 使用 f7TabLayout 带有底部导航栏
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 添加 id="tabs" 让 f7TabLink 可以控制 f7Tabs
    f7Tabs(
      id = "tabs",
      swipeable = FALSE,
      animated = TRUE,
      
      # 商品搜索页面
      f7Tab(
        tabName = "商品搜索",
        icon = f7Icon("search"),
        active = TRUE,
        
        # 将搜索框从固定定位改为粘性定位，
        # 这样它会在页面内固定在距离顶部 40px 的位置，但不会覆盖底部导航栏
        div(
          style = "position: sticky; top: 40px; z-index: 500; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc;",
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
        
        # 搜索结果区域，注意这里根据页面内容高度设置了合适的高度
        div(
          style = "padding: 10px; overflow-y: auto; height: calc(100vh - 150px);",
          uiOutput("search_results")
        )
      ),
      
      # 订单查询页面
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
    
    # 底部导航栏，使用正确的 tab 名称
    f7Toolbar(
      position = "bottom",
      icons = TRUE,
      f7TabLink(tab = "商品搜索", icon = f7Icon("search"), label = "商品"),
      f7TabLink(tab = "订单查询", icon = f7Icon("cart"), label = "订单")
    )
  )
)