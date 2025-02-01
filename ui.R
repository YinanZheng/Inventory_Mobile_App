ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
  f7TabLayout(
    navbar = f7Navbar(
      title = "📦 库存 & 订单查询",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    f7Tabs(
      animated = TRUE,
      
      # 📦 物品搜索页面
      f7Tab(
        tabName = "物品搜索",
        icon = f7Icon("cube", color = "blue"),
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          f7Text("search_sku", "输入 SKU", style = "background-color: white; color: black;"),
          f7Text("search_name", "输入物品名称（可选）", style = "background-color: white; color: black;"),
          br(),
          f7Button("search_item", "🔎 查询", color = "green", fill = TRUE),
          br(),
          uiOutput("item_result"),  # 显示物品详情
          plotlyOutput("inventory_status_chart")  # 库存状态饼图
        )
      ),
      
      # 📜 订单搜索页面
      f7Tab(
        tabName = "订单搜索",
        icon = f7Icon("cart", color = "red"),
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          f7Text("search_order_id", "输入订单号", style = "background-color: white; color: black;"),
          f7Text("search_tracking", "输入运单号（可选）", style = "background-color: white; color: black;"),
          br(),
          f7Button("search_order", "🔎 查询", color = "green", fill = TRUE),
          br(),
          uiOutput("order_result")
        )
      )
    )
  )
)
