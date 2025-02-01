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
      animated = TRUE,
      
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
            style = "display: flex; flex-wrap: wrap; justify-content: space-around; gap: 20px;",
            
            # 物品搜索图标
            div(
              style = "text-align: center;",
              div(
                style = "width: 80px; height: 80px; display: flex; justify-content: center; align-items: center; border-radius: 10px; background-color: #007BFF; color: #fff;",
                f7Button(
                  inputId = "go_to_search",  # 点击按钮触发事件
                  label = NULL,
                  icon = f7Icon("search"),
                  fill = TRUE,
                  color = NULL  # 使用自定义颜色
                )
              ),
              div(style = "margin-top: 5px;", "物品搜索")
            ),
            
            # 其他功能图标（占位）
            div(
              style = "text-align: center;",
              div(
                style = "width: 80px; height: 80px; display: flex; justify-content: center; align-items: center; border-radius: 10px; background-color: #007BFF; color: #fff;",
                f7Button(
                  inputId = "go_to_other",  # 其他功能按钮
                  label = NULL,
                  icon = f7Icon("cube_box"),
                  fill = TRUE,
                  color = NULL
                )
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
          style = "position: fixed; top: 50px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px 10px 5px; border-bottom: 1px solid #ccc;",
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
