ui <- f7Page(
  title = "库存管理系统（移动端）",
  allowPWA = TRUE,  # ✅ 启用 PWA
  options = list(dark = FALSE),
  
  # 采用 f7TabLayout，带有底部导航栏
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 添加 PWA 资源
    tags$head(
      tags$link(rel = "manifest", href = "www/manifest.webmanifest"),
      tags$script(src = "www/service-worker.js"),
      tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
      tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "black-translucent"),
      tags$meta(name = "apple-mobile-web-app-title", content = "库存管理")
    ),
    
    # 全局样式优化
    tags$style(HTML("
      /* 移除输入框外层多余的边距 */
      .list {
        margin: 0 !important;
        padding: 10px !important;
    ")),
    
    # 主要功能页面
    f7Tabs(
      swipeable = FALSE,
      animated = TRUE,
      
      # 商品搜索
      f7Tab(
        tabName = "商品查询",
        icon = f7Icon("tag"),

        # 固定搜索框
        div(
          style = "position: fixed; top: 100px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px 5px; border-bottom: 1px solid #ccc; display: flex; flex-direction: column; align-items: center;",
          
          # 标题
          div(
            style = "
              text-align: center; 
              font-size: 18px; 
              font-weight: bold; 
              color: white; 
              background: #7598ff; 
              border-radius: 8px; 
              padding: 0px 10px; 
              line-height: 1.2; 
              margin-bottom: 10px; 
              width: 100%; 
              max-width: 300px;
            ",
            "商品库存查询"
          ),
          
          # 输入框
          div(
            style = "width: 100%; max-width: 500px;",
            f7Text(
              inputId = "search_sku_item",
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
          uiOutput("item_search_results")
        )
      ),
      
      # 订单查询
      f7Tab(
        tabName = "订单查询",
        icon = f7Icon("cube_box"),

        # # 固定搜索框
        div(
          style = "left: 0; right: 0; z-index: 2000; background-color: #f7f7f8; padding: 10px 5px; border-bottom: 1px solid #ccc; display: flex; flex-direction: column; align-items: center;",

          # 标题
          div(
            style = "
              text-align: center;
              font-size: 18px;
              font-weight: bold;
              color: white;
              background: #7598ff;
              border-radius: 8px;
              padding: 0px 10px;
              line-height: 1.2;
              margin-bottom: 10px;
              width: 100%;
              max-width: 300px;
            ",
            "订单状态查询"
          ),

          # 输入框
          div(
            style = "width: 100%; max-width: 500px;",
            f7Text(
              inputId = "search_order_label",
              label = NULL,
              placeholder = "输入 订单号 / 运单号..."
            )
          )
        ),

        # 占位符，避免内容被搜索框遮挡
        div(style = "height: 100px;"),

        # 让整个页面滚动，而不是搜索结果区域
        div(
          style = "min-height: 100vh; padding-bottom: 60px;",
          uiOutput("order_search_results")
        )
      )
    )
  )
)
