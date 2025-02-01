ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
  f7TabLayout(
    navbar = f7Navbar(
      title = tags$span("📦 库存 & 订单查询", style = "font-weight: bold;"),
      hairline = FALSE,
      shadow = TRUE
    ),
    
    f7Tabs(
      animated = TRUE,
      
      # 📦 物品搜索页面
      f7Tab(
        tabName = "物品搜索",
        icon = f7Icon("cube", color = "blue"),
        
        f7Card(
          title = "🔍 搜索库存",
          f7Text("search_sku", "输入 SKU 或使用扫码", placeholder = "例如：SKU123456"),
          f7Button("scan_sku", "📸 扫描 SKU", color = "blue"),
          f7Text("search_name", "输入物品名称（可选）", placeholder = "例如：乐高积木"),
          f7Button("search_item", "🔎 查询", color = "green"),
          br(),
          uiOutput("item_result")
        )
      ),
      
      # 📜 订单搜索页面
      f7Tab(
        tabName = "订单搜索",
        icon = f7Icon("cart", color = "red"),
        
        f7Card(
          title = "📦 订单查询",
          f7Text("search_order_id", "输入订单号或使用扫码", placeholder = "例如：ORD12345"),
          f7Button("scan_order_id", "📸 扫描订单", color = "red"),
          f7Text("search_tracking", "输入运单号（可选）", placeholder = "例如：US123456789"),
          f7Button("search_order", "🔎 查询", color = "green"),
          br(),
          uiOutput("order_result")
        )
      )
    )
  ),
  
  # 📸 摄像头扫码窗口
  tags$div(id = "scanner-container", style = "display:none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.8); z-index: 9999;"),
  tags$video(id = "scanner-video", autoplay = NA, style = "width: 100%; display: none;"),
  tags$button(id = "stop-scanner", "❌ 停止扫描", style = "position: fixed; top: 10px; right: 10px; z-index: 10000; background: red; color: white; padding: 10px; display: none;"),
  
  # 📸 QuaggaJS 扫描器
  tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/quagga/0.12.1/quagga.min.js"),
  
  # 📜 JavaScript 逻辑：扫码成功后填充输入框
  tags$script(HTML("
    function startScanner(inputId) {
      document.getElementById('scanner-container').style.display = 'block';
      document.getElementById('scanner-video').style.display = 'block';
      document.getElementById('stop-scanner').style.display = 'block';

      Quagga.init({
        inputStream: {
          name: 'Live',
          type: 'LiveStream',
          target: document.querySelector('#scanner-video'),
          constraints: { facingMode: 'environment' }
        },
        decoder: { readers: ['ean_reader', 'code_128_reader'] }
      }, function(err) {
        if (err) {
          console.error(err);
          alert('无法启动摄像头，请检查浏览器权限！');
          return;
        }
        Quagga.start();
      });

      Quagga.onDetected(function(result) {
        var code = result.codeResult.code;
        console.log('Scanned code:', code);
        Shiny.setInputValue(inputId, code, {priority: 'event'});
        stopScanner();
      });
    }

    function stopScanner() {
      Quagga.stop();
      document.getElementById('scanner-container').style.display = 'none';
      document.getElementById('scanner-video').style.display = 'none';
      document.getElementById('stop-scanner').style.display = 'none';
    }

    document.getElementById('stop-scanner').addEventListener('click', stopScanner);
  "))
)
