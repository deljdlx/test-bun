// Simple serveur HTTP avec Bun
const server = Bun.serve({
  port: 3333,
  fetch(_req) {
    return new Response("Hello World yolo  🌍", {
      headers: {
        "Content-Type": "text/html; charset=utf-8",
      },
    });
  },
});

console.log(`🚀 Serveur Bun lancé sur http://localhost:${server.port}`);
