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
      
      tags$script(src = "https://www.goldenbeanllc.com/js/service-worker.js"),
      tags$script(src = "https://www.goldenbeanllc.com/js/quagga.min.js"),
      tags$script(src = "https://www.goldenbeanllc.com/js/scan.js"),
      
      tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
      tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "black-translucent"),
      tags$meta(name = "apple-mobile-web-app-title", content = "库存管理"),
      
      tags$script(HTML("
  Shiny.addCustomMessageHandler('startBarcodeScanner', function(inputId) {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert('此设备不支持摄像头扫码');
      return;
    }

    // ✅ 创建扫码界面（优化按钮宽度）
    let scannerArea = document.createElement('div');
    scannerArea.style.position = 'fixed';
    scannerArea.style.top = '0';
    scannerArea.style.left = '0';
    scannerArea.style.width = '100vw';
    scannerArea.style.height = '100vh';
    scannerArea.style.backgroundColor = 'rgba(0,0,0,0.8)';
    scannerArea.style.zIndex = '10000';
    scannerArea.innerHTML = `
      <video id='barcode-scanner' style='width:100%; height:60vh; display:block; margin: auto; margin-top: 35vh; object-fit: contain;'></video>
      <div style='position: fixed; bottom: 80px; left: 50%; transform: translateX(-50%); display: flex; gap: 15px;'>
        <button id='toggle-flash' style='min-width: 140px; padding: 12px 24px; background-color: #ffcc00; color: black; border: none; font-size: 16px; cursor: pointer; border-radius: 8px; text-align: center;'>
          开启照明
        </button>
        <button id='close-scanner' style='min-width: 140px; padding: 12px 24px; background-color: red; color: white; border: none; font-size: 16px; cursor: pointer; border-radius: 8px; text-align: center;'>
          返回
        </button>
      </div>
    `;
    document.body.appendChild(scannerArea);

    let video = document.getElementById('barcode-scanner');
    let flashEnabled = false; // ✅ 记录闪光灯状态
    let scanning = false;  // ✅ 防止重复扫码
    let streamRef = null;  // ✅ 存储摄像头流，方便控制闪光灯

    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
      .then(stream => {
        video.srcObject = stream;
        video.setAttribute('playsinline', true);
        video.play();
        streamRef = stream;

        Quagga.init({
          inputStream: {
            name: 'Live',
            type: 'LiveStream',
            target: video
          },
          decoder: {
            readers: ['ean_reader', 'code_128_reader']
          },
          locate: true,
          halfSample: false, // ✅ 关闭 halfSample，提高识别率
          multiple: false, // ✅ 只识别一个条码，防止误识别
          area: {
            top: '10%',    // ✅ 让 Quagga 识别整个中间部分
            right: '10%',
            bottom: '90%',
            left: '10%'
          }
        }, function(err) {
          if (err) {
            console.error('Quagga 初始化失败:', err);
            return;
          }
          Quagga.start();
        });

        // ✅ 监听 Quagga 识别到的条形码
        Quagga.onDetected(function(result) {
          if (scanning) return;  // ✅ 防止重复触发
          scanning = true;

          let code = result.codeResult.code;
          console.log('扫码成功:', code);

          // ✅ 发送扫码结果到 Shiny，并触发 showNotification
          Shiny.setInputValue(inputId, code, { priority: 'event' });
          Shiny.setInputValue('scan_result_notification', '扫描成功: ' + code, { priority: 'event' });

          // ✅ 先停止 Quagga，再关闭摄像头
          Quagga.stop();
          setTimeout(() => {
            stopScanner();
          }, 500);
        });

        // ✅ 监听返回按钮，手动关闭摄像头
        document.getElementById('close-scanner').addEventListener('click', function() {
          console.log('用户点击返回');
          stopScanner();
        });

        // ✅ 监听闪光灯按钮
        document.getElementById('toggle-flash').addEventListener('click', function() {
          let tracks = streamRef.getVideoTracks();
          if (tracks.length > 0 && tracks[0].getCapabilities().torch) {
            flashEnabled = !flashEnabled;
            tracks[0].applyConstraints({ advanced: [{ torch: flashEnabled }] });
            this.textContent = flashEnabled ? '关闭照明' : '开启照明';
          } else {
            alert('此设备不支持闪光灯控制');
          }
        });

        // ✅ 关闭摄像头的函数
        function stopScanner() {
          console.log('关闭摄像头');
          if (streamRef) {
            streamRef.getTracks().forEach(track => track.stop());
          }
          document.body.removeChild(scannerArea);
        }

      }).catch(err => {
        alert('无法访问摄像头: ' + err);
        document.body.removeChild(scannerArea);
      });
  });
"))
    
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
        
        div(
          style = "background-color: #f7f7f8; padding: 10px 5px; border-bottom: 1px solid #ccc; display: flex; flex-direction: column; align-items: center;",
          
          # 标题
          div(
            style = "text-align: center; font-size: 20px; font-weight: bold; 
             color: #333; padding: 12px 0; border-bottom: 3px solid #007aff; 
             width: 100%; max-width: 500px;",
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
          ),
          
          # 扫码按钮
          f7Button(
            inputId = "scan_barcode_sku",
            label = "扫码查询",
            color = "blue",
            fill = TRUE
          ),
        ),
        
        # 搜索结果
        div(
          style = "min-height: 100vh; padding-bottom: 60px;",
          uiOutput("item_search_results")
        )
      ),
      
      # 订单查询
      f7Tab(
        tabName = "订单查询",
        icon = f7Icon("cube_box"),
        
        div(
          style = "background-color: #f7f7f8; padding: 10px 5px; border-bottom: 1px solid #ccc; display: flex; flex-direction: column; align-items: center;",
          
          # 标题
          div(
            style = "text-align: center; font-size: 20px; font-weight: bold; 
             color: #333; padding: 12px 0; border-bottom: 3px solid #007aff; 
             width: 100%; max-width: 500px;",            
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
          ),
          
          # 扫码按钮
          f7Button(
            inputId = "scan_barcode_order",
            label = "扫码查询",
            color = "blue",
            fill = TRUE
          ),
          
          # 搜索结果
          div(
            style = "min-height: 100vh; padding-bottom: 60px;",
            uiOutput("order_search_results")
          )
        )
      )
    )
  )
)
