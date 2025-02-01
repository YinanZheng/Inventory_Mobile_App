ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  # 主页 + 物品搜索等功能分页
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 选项卡
    f7Tabs(
      animated = TRUE,  # 添加动画切换

      # 主页
      f7Tab(
        tabName = "主页",
        icon = f7Icon("house_fill"),  # 使用房屋图标表示首页
        active = TRUE,  # 默认进入主页
        
        f7Block(
          title = "功能选择",
          strong = TRUE,
          inset = TRUE,
          
          div(
            style = "display: flex; flex-wrap: wrap; justify-content: space-around; gap: 20px; padding: 10px;",
            
            # 物品搜索图标
            div(
              style = "text-align: center;",
              f7Button(
                inputId = "go_to_search",  # 绑定事件以切换分页
                label = NULL,
                icon = f7Icon("search"),
                color = "blue",
                fill = TRUE,
                style = "width: 80px; height: 80px; font-size: 20px;"
              ),
              div(style = "margin-top: 5px;", "物品搜索")
            ),
            
            # 其他功能（示例）
            div(
              style = "text-align: center;",
              f7Button(
                inputId = "go_to_other",  
                label = NULL,
                icon = f7Icon("cube_box"),
                color = "blue",
                fill = TRUE,
                style = "width: 80px; height: 80px; font-size: 20px;"
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
        
        # 搜索框
        div(
          style = "position: fixed; top: 50px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc;",
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
