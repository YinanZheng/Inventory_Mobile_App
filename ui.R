ui <- f7Page(
  title = "库存 & 订单查询",
  allowPWA = TRUE,
  
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
          f7Text("search_sku", "输入 SKU"),
          f7Button("scan_sku", "📸 扫描 SKU", color = "blue"),
          f7Text("search_name", "输入物品名称（可选）"),
          br(),
          f7Button("search_item", "🔎 查询", color = "green", fill = TRUE),
          br(),
          uiOutput("item_result")  # 物品查询结果
        )
      ),
      
      # 📜 订单搜索页面
      f7Tab(
        tabName = "订单搜索",
        icon = f7Icon("cart", color = "red"),
        
        f7Block(
          strong = TRUE,
          inset = TRUE,
          f7Text("search_order_id", "输入订单号"),
          f7Button("scan_order_id", "📸 扫描订单", color = "red"),
          f7Text("search_tracking", "输入运单号（可选）"),
          br(),
          f7Button("search_order", "🔎 查询", color = "green", fill = TRUE),
          br(),
          uiOutput("order_result")  # 订单查询结果
        )
      )
    )
  ),
  
  # 📸 摄像头扫码窗口
  tags$div(id = "scanner-container", style = "display:none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.8); z-index: 9999;"),
  tags$video(id = "scanner-video", autoplay = NA, style = "width: 100%; display: none;"),
  tags$button(id = "stop-scanner", "❌ 停止扫描", style = "position: fixed; top: 10px; right: 10px; z-index: 10000; background: red; color: white; padding: 10px; display: none;"),
  
  # 📸 修正 iOS Safari 无法扫描问题
  tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/quagga/0.12.1/quagga.min.js"),
  tags$script(HTML("
    function startScanner(inputId) {
      // 确保摄像头权限
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        alert('此设备不支持摄像头访问，请检查权限！');
        return;
      }
  
      navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
        .then(function(stream) {
          console.log('摄像头访问成功');
          document.getElementById('scanner-container').style.display = 'block';
          let videoElement = document.getElementById('scanner-video');
          videoElement.srcObject = stream;
          videoElement.play();
          document.getElementById('stop-scanner').style.display = 'block';
        })
        .catch(function(err) {
          console.error('摄像头访问失败:', err);
          alert('无法访问摄像头，请在 Safari 设置中启用摄像头权限！');
          return;
        });
  
      // 确保 QuaggaJS 正确初始化
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
          console.error('QuaggaJS 初始化失败:', err);
          alert('扫码功能启动失败，请重试！');
          return;
        }
        console.log('QuaggaJS 启动成功');
        Quagga.start();
      });
  
      Quagga.onDetected(function(result) {
        let code = result.codeResult.code;
        console.log('扫描结果:', code);
        Shiny.setInputValue(inputId, code, { priority: 'event' });
        stopScanner();
      });
    }
  
    function stopScanner() {
      console.log('停止摄像头 & QuaggaJS');
      let video = document.getElementById('scanner-video');
      if (video.srcObject) {
        let stream = video.srcObject;
        let tracks = stream.getTracks();
        tracks.forEach(track => track.stop());
        video.srcObject = null;
      }
      document.getElementById('scanner-container').style.display = 'none';
      document.getElementById('stop-scanner').style.display = 'none';
      Quagga.stop();
    }
  
    function openImage(src) {
      let newTab = window.open();
      newTab.document.write('<img src=\"' + src + '\" style=\"width:100%\">');
      newTab.document.title = '图片预览';
    }
  "))
)
