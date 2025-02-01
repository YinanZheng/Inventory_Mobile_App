ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  f7TabLayout(
    navbar = f7Navbar(title = "查询系统"),
    f7Tabs(
      animated = TRUE,
      
      # 物品搜索页面
      f7Tab(
        tabName = "物品搜索",
        icon = f7Icon("cube"),
        f7Text("search_sku", "输入 SKU 或使用扫码"),
        actionButton("scan_sku", "扫描 SKU 条形码"),
        f7Text("search_name", "输入物品名称（模糊搜索）"),
        f7Button("search_item", "搜索"),
        uiOutput("item_result")
      ),
      
      # 订单搜索页面
      f7Tab(
        tabName = "订单搜索",
        icon = f7Icon("cart"),
        f7Text("search_order_id", "输入订单号"),
        actionButton("scan_order_id", "扫描订单条形码"),
        f7Text("search_tracking", "输入运单号"),
        actionButton("scan_tracking", "扫描运单条形码"),
        f7Button("search_order", "搜索"),
        uiOutput("order_result")
      )
    )
  ),
  
  # 添加摄像头扫码的 HTML 组件
  tags$div(id = "scanner-container", style = "display:none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.8); z-index: 9999;"),
  tags$video(id = "scanner-video", autoplay = NA, style = "width: 100%; display: none;"),
  tags$button(id = "stop-scanner", "停止扫描", style = "position: fixed; top: 10px; right: 10px; z-index: 10000; background: red; color: white; padding: 10px; display: none;"),
  
  # 这里插入 QuaggaJS 扫描器
  tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/quagga/0.12.1/quagga.min.js"),
  
  # JavaScript 扫码逻辑
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
          constraints: { facingMode: 'environment' } // 后置摄像头
        },
        decoder: { readers: ['ean_reader', 'code_128_reader'] } // 适用于商品条码和128码
      }, function(err) {
        if (err) {
          console.error(err);
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
