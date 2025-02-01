ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统"
    ),
    # 注意：设置 id="tabs"，供 f7TabLink 识别
    f7Tabs(
      id = "tabs",
      swipeable = FALSE,
      animated = TRUE,
      
      # 商品搜索页面，内部 tabName 用纯英文标识
      f7Tab(
        tabName = "tab_search", 
        icon = f7Icon("search"),
        active = TRUE,
        div(
          style = "padding: 10px;",
          h3("商品搜索"),
          # 搜索框区域
          div(
            style = "display: flex; align-items: center; margin-bottom: 10px;",
            div(
              style = "flex:2; margin-right: 10px;",
              f7Text(
                inputId = "search_sku",
                label = NULL,
                placeholder = "输入 SKU 或物品名..."
              )
            ),
            div(
              style = "flex:1;",
              f7Button(
                inputId = "search_btn",
                label = "查询",
                color = "blue",
                fill = TRUE
              )
            )
          ),
          # 搜索结果区域
          uiOutput("search_results")
        )
      ),
      
      # 订单查询页面，内部 tabName 用纯英文标识
      f7Tab(
        tabName = "tab_orders",
        icon = f7Icon("cart"),
        div(
          style = "padding: 10px;",
          h3("订单查询"),
          "这里是订单管理页面"
        )
      )
    ),
    
    # 底部导航栏，tab 参数对应内部的 tabName（纯英文）
    f7Toolbar(
      position = "bottom",
      icons = TRUE,
      f7TabLink(tab = "tab_search", icon = f7Icon("search"), label = "商品"),
      f7TabLink(tab = "tab_orders", icon = f7Icon("cart"), label = "订单")
    )
  )
)