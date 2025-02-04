const CACHE_NAME = "inventory-cache-v1";
const urlsToCache = [
  "/erp-mobile/",
  "/erp-mobile/index.html",
  "/erp-mobile/www/manifest.webmanifest",
  "/js/quagga.min.js",
  "/js/scan.js",     
  "/js/service-worker.js"  
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache);
    })
  );
});

self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      );
    })
  );
});
