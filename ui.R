ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  f7TabLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    f7Tabs(
      animated = TRUE,
      
      # 主页
      f7Tab(
        tabName = "主页",
        icon = f7Icon("house_fill"),
        active = TRUE,
        
        f7Block(
          title = "功能选择",
          strong = TRUE,
          inset = TRUE,
          div(
            style = "display: flex; flex-wrap: wrap; justify-content: space-around; gap: 20px; padding: 10px;",
            
            # 物品搜索按钮
            div(
              style = "text-align: center;",
              div(
                style = "font-size: 36px; color: #007BFF;",
                f7Link(
                  label = "物品搜索",
                  href = "#tab-物品搜索",
                  icon = f7Icon("search")
                )
              )
            )
          )
        )
      ),
      
      # 物品搜索页面
      f7Tab(
        tabName = "物品搜索",
        icon = f7Icon("search"),
        active = FALSE,
        
        div(
          style = "position: fixed; top: 50px; left: 0; right: 0; z-index: 1000; background-color: #f7f7f8; padding: 10px; border-bottom: 1px solid #ccc;",
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
        
        div(
          style = "margin-top: 120px; padding: 10px; overflow-y: auto; height: calc(100vh - 130px);",
          uiOutput("search_results")
        )
      )
    )
  )
)
