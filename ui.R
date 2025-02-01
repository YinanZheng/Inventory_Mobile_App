ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
  tags$script(HTML("
    function showImageModal(src) {
      document.getElementById('modalImage').src = src;
      Shiny.setInputValue('imageModal', { open: true }, { priority: 'event' });
    }
  
    function closeImageModal() {
      Shiny.setInputValue('imageModal', { open: false }, { priority: 'event' });
    }
  ")),
    
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
          uiOutput("item_result"),  
          plotlyOutput("inventory_status_chart")  
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
  ),
  
  # 📸 图片查看 modal
  f7Sheet(
    id = "imageModal",
    title = "图片预览",
    swipeToClose = TRUE,
    backdrop = TRUE,
    f7Block(
      tags$img(id = "modalImage", src = "", style = "width:100%; border-radius: 8px;"),
      br(),
      f7Button("close_modal", "关闭", color = "red", fill = TRUE)
    )
  )
)
