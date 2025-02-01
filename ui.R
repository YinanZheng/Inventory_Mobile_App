ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
  # 注意：在 shinyMobile 2.0.1 中，不再使用 f7Tabs() 单独构建标签页，
  # 而是直接在 f7TabLayout() 中通过参数 tabs 来传入一个列表
  f7TabLayout(
    navbar = f7Navbar(
      title = tags$span("📦 库存 & 订单查询", style = "font-weight: bold;"),
      hairline = FALSE,
      shadow = TRUE
    ),
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
          # 为输入框设置背景为白色、文字为黑色，提升手机端可读性
          f7Text("search_sku", "输入 SKU", style = "background-color: #fff; color: #000;"),
          f7Text("search_name", "输入物品名称（可选）", style = "background-color: #fff; color: #000;"),
          br(),
          f7Button("search_item", "🔎 查询", color = "green", fill = TRUE),
          br(),
          # 展示查询结果（图片和详细信息）
          uiOutput("query_item_info")
        )
      ),
      
      # 订单搜索页面（示例代码，查询逻辑待补充）
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
