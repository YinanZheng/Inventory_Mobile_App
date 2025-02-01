ui <- f7Page(
  title = "库存管理系统（移动端）",
  options = list(dark = FALSE),
  
  f7SingleLayout(
    navbar = f7Navbar(
      title = "库存管理系统（移动端）",
      hairline = FALSE,
      shadow = TRUE
    ),
    
    # 搜索框
    f7Block(
      strong = TRUE,
      inset = TRUE,
      div(
        style = "border: 1px solid #ccc; border-radius: 8px; padding: 10px; background-color: #fff;",
        f7Text(
          inputId = "search_sku",
          label = "SKU / 物品名",
          placeholder = "输入 SKU 或 物品名..."
        )
      ),
      div(
        style = "margin-top: 10px;",  
        f7Button(inputId = "search_btn", label = "查询", color = "blue")
      )
    ),
    
    # 物品信息显示
    uiOutput("item_info"),
    
    # 库存状态表格（仅在搜索后显示）
    uiOutput("stock_table_ui")
  )
)
