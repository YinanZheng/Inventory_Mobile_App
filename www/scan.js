document.addEventListener("DOMContentLoaded", function () {
  if (typeof Quagga === "undefined") {
    console.error("Quagga.js 未加载，请检查 www 目录下的 quagga.min.js");
    return;
  }

  let scanning = false; // 防止重复触发

  const startScanner = () => {
    if (scanning) return;
    scanning = true;

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert("你的设备不支持摄像头访问");
      scanning = false;
      return;
    }

    let scannerContainer = document.querySelector("#scanner-container");
    scannerContainer.style.display = "block";

    Quagga.init(
      {
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: scannerContainer,
          constraints: {
            width: 480,
            height: 320,
            facingMode: "environment",
          },
        },
        decoder: {
          readers: ["ean_reader", "code_128_reader"],
        },
        locator: {
          halfSample: true,
          patchSize: "medium",
        },
      },
      function (err) {
        if (err) {
          console.error("Quagga 初始化失败:", err);
          scanning = false;
          return;
        }
        Quagga.start();
      }
    );

    Quagga.onDetected(function (result) {
      let code = result.codeResult.code;
      document.querySelector("#barcode-result").textContent = "扫描结果: " + code;
      Quagga.stop();
      scannerContainer.style.display = "none";
      scanning = false;
      Shiny.setInputValue("search_order_label", code, { priority: "event" });
    });
  };

  document.querySelector("#start-scan-btn").addEventListener("click", startScanner);
});
