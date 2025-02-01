ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 主页面布局
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 主页面选项卡
    f7Tabs(
      animated = TRUE,  # 保留动画效果，去掉 swipeable
      
      # 首页功能图标
      f7Tab(
        tabName = "主页",
        icon = f7Icon("home"),
        active = TRUE,
        
        f7Block(
          title = "功能选择",
          strong = TRUE,
          inset = TRUE,
          div(
            style = "display: flex; flex-wrap: wrap; justify-content: space-around;",
            
            # 物品搜索图标
            div(
              style = "text-align: center; margin: 10px;",
              f7Link(
                label = NULL,
                href = "#search",  # 跳转到物品搜索页面
                icon = f7Icon("search"),
                style = "font-size: 36px; color: #007BFF;"
              ),
              div(style = "margin-top: 5px;", "物品搜索")
            ),
            
            # 其他功能图标（可扩展）
            div(
              style = "text-align: center; margin: 10px;",
              f7Link(
                label = NULL,
                href = "#other-feature",  # 跳转到其他功能页面（占位）
                icon = f7Icon("cube_box"),
                style = "font-size: 36px; color: #007BFF;"
              ),
              div(style = "margin-top: 5px;", "其他功能")
            )
          )
        )
      ),
      
      # 物品搜索页面
      f7Tab(
        tabName = "物品搜索",
        icon = f7Icon("search"),
        active = FALSE,
        
        # 固定搜索框
        div(
          style = "position: fixed; top: 40px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px 10px 5px; border-bottom: 1px solid #ccc;",
          f7Block(
            strong = FALSE,
            inset = FALSE,
            style = "padding: 0; margin: 0;",
            
            div(
              style = "display: flex; align-items: center; justify-content: space-between;",
              
              # 输入框
              div(
                style = "flex: 2; margin-right: 10px;",
                f7Text(
                  inputId = "search_sku",
                  label = NULL,
                  placeholder = "输入 SKU 或 物品名..."
                )
              ),
              
              # 查询按钮
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
      )
    )
  )
)
