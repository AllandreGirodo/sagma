// Basic service worker required by Firebase Messaging on Flutter Web.
// This keeps registration valid in local development and production builds.
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});
