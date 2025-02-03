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
      
      tags$script(src = "www/service-worker.js"),
      tags$script(src = "www/quagga.min.js"),
      tags$script(src = "www/scan.js"),
      
      tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
      tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "black-translucent"),
      tags$meta(name = "apple-mobile-web-app-title", content = "库存管理"),
      
      tags$script(HTML("
        Shiny.addCustomMessageHandler('startBarcodeScanner', function(inputId) {
          if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            alert('此设备不支持摄像头扫码');
            return;
          }
    
          let scannerArea = document.createElement('div');
          scannerArea.style.position = 'fixed';
          scannerArea.style.top = '0';
          scannerArea.style.left = '0';
          scannerArea.style.width = '100vw';
          scannerArea.style.height = '100vh';
          scannerArea.style.backgroundColor = 'rgba(0,0,0,0.7)';
          scannerArea.style.zIndex = '10000';
          scannerArea.innerHTML = '<video id=\"barcode-scanner\" style=\"width:100%; height:auto;\"></video>';
          document.body.appendChild(scannerArea);
    
          let video = document.getElementById('barcode-scanner');
    
          navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
            .then(stream => {
              video.srcObject = stream;
              video.setAttribute('playsinline', true);
              video.play();
    
              Quagga.init({
                inputStream: {
                  name: 'Live',
                  type: 'LiveStream',
                  target: video
                },
                decoder: {
                  readers: ['ean_reader', 'code_128_reader']
                }
              }, function(err) {
                if (err) {
                  console.error('Quagga 初始化失败:', err);
                  return;
                }
                Quagga.start();
              });
    
              Quagga.onDetected(function(result) {
                let code = result.codeResult.code;
                Shiny.setInputValue(inputId, code, { priority: 'event' });
    
                // ✅ 停止摄像头
                stream.getTracks().forEach(track => track.stop());
                Quagga.stop();
                document.body.removeChild(scannerArea);
              });
            })
            .catch(err => {
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
          )
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
            label = "扫码输入",
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
