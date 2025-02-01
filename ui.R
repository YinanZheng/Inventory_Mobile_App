ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
  f7TabLayout(
    navbar = f7Navbar(
      title = tags$span("📦 库存 & 订单查询", style = "font-weight: bold;"),
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 在 shinyMobile 2.0.1 中，f7Tabs() 必须使用 tabs 参数传入列表
    f7Tabs(
      animated = TRUE,
      tabs = list(
        # 物品搜索页面
        f7Tab(
          tabName = "物品搜索",
          icon = f7Icon("cube", color = "blue"),
          f7Block(
            strong = TRUE,
            inset = TRUE,
            tags$h3("🔍 搜索库存", style = "color: #007AFF; text-align: center;"),
            # 优化输入框样式：背景白色，文字黑色
            f7Text("search_sku", "输入 SKU", style = "background-color: #fff; color: #000;"),
            f7Text("search_name", "输入物品名称（可选）", style = "background-color: #fff; color: #000;"),
            br(),
            f7Button("search_item", "🔎 查询", color = "green", fill = TRUE),
            br(),
            # 查询结果：包含图片和详细信息的表格
            uiOutput("query_item_info")
          )
        ),
        
        # 订单搜索页面（示例中未实现具体查询逻辑，可根据需要扩展）
        f7Tab(
          tabName = "订单搜索",
          icon = f7Icon("cart", color = "red"),
          f7Block(
            strong = TRUE,
            inset = TRUE,
            tags$h3("📦 订单查询", style = "color: #FF3B30; text-align: center;"),
            f7Text("search_order_id", "输入订单号", style = "background-color: #fff; color: #000;"),
            f7Text("search_tracking", "输入运单号（可选）", style = "background-color: #fff; color: #000;"),
            br(),
            f7Button("search_order", "🔎 查询", color = "green", fill = TRUE),
            br(),
            uiOutput("order_result")
          )
        )
      )
    )
  )
)
