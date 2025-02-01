
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
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          tags$h3("🔍 搜索库存", style = "color: #007AFF; text-align: center;"),
          f7Text("search_sku", "输入 SKU"),
          f7Button("scan_sku", "📸 扫描 SKU", color = "blue"),
          f7Text("search_name", "输入物品名称（可选）"),
          br(),
          f7Button("search_item", "🔎 查询", color = "green", fill = TRUE),
          br(),
          uiOutput("item_result")
        )
      ),
      
      # 📜 订单搜索页面
      f7Tab(
        tabName = "订单搜索",
        icon = f7Icon("cart", color = "red"),
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          tags$h3("📦 订单查询", style = "color: #FF3B30; text-align: center;"),
          f7Text("search_order_id", "输入订单号"),
          f7Button("scan_order_id", "📸 扫描订单", color = "red"),
          f7Text("search_tracking", "输入运单号（可选）"),
          br(),
          f7Button("search_order", "🔎 查询", color = "green", fill = TRUE),
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
      navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
        .then(function(stream) {
          document.getElementById('scanner-container').style.display = 'block';
          document.getElementById('scanner-video').srcObject = stream;
          document.getElementById('stop-scanner').style.display = 'block';
        })
        .catch(function(err) {
          alert('无法访问摄像头，请检查权限！');
        });

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
          alert('摄像头启动失败！');
          return;
        }
        Quagga.start();
      });

      Quagga.onDetected(function(result) {
        var code = result.codeResult.code;
        Shiny.setInputValue(inputId, code, {priority: 'event'});
        stopScanner();
      });
    }

    function stopScanner() {
      let video = document.getElementById('scanner-video');
      let stream = video.srcObject;
      let tracks = stream.getTracks();

      tracks.forEach(track => track.stop());
      video.srcObject = null;
      
      document.getElementById('scanner-container').style.display = 'none';
      document.getElementById('stop-scanner').style.display = 'none';
    }
  "))
)
