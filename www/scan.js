document.addEventListener("DOMContentLoaded", function () {
  const startScanner = () => {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert("你的设备不支持摄像头访问");
      return;
    }

    Quagga.init(
      {
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: document.querySelector("#scanner-container"),
          constraints: {
            width: 480,
            height: 320,
            facingMode: "environment",
          },
        },
        decoder: {
          readers: ["ean_reader", "code_128_reader"],
        },
      },
      function (err) {
        if (err) {
          console.error("Quagga初始化失败:", err);
          return;
        }
        Quagga.start();
      }
    );

    Quagga.onDetected(function (result) {
      let code = result.codeResult.code;
      document.querySelector("#barcode-result").textContent = "扫描结果: " + code;
      Quagga.stop();
    });
  };

  document.querySelector("#start-scan-btn").addEventListener("click", startScanner);
});
