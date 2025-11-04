#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="adonis-hello"
APP_DIR="./$PROJECT_NAME"

echo "🚀 Provision AdonisJS v6 minimal (Hello World)"

# Préreq: bun pour lancer le scaffolder (bunx)
if ! command -v bun >/dev/null 2>&1; then
  echo "❌ Bun n'est pas installé (nécessaire pour bunx)."
  echo "   curl -fsSL https://bun.sh/install | bash"
  exit 1
fi

# Clean & scaffold (IMPORTANT: on laisse le scaffolder créer le dossier)
rm -rf "$APP_DIR"
bunx --bun create-adonisjs@latest "$PROJECT_NAME" --kit=api

# Écrase la route d'accueil
ROUTES_FILE="$APP_DIR/start/routes.ts"
if [ -f "$ROUTES_FILE" ]; then
  cat > "$ROUTES_FILE" <<'EOF'
import router from '@adonisjs/core/services/router'

router.get('/', async () => {
  return 'Hello World 👋'
})
EOF
else
  echo "❌ start/routes.ts introuvable (scaffold a échoué ?)."
  exit 1
fi

# Dockerfile (Debian + Node 22 + Bun) pour dev
cat > "$APP_DIR/Dockerfile" <<'EOF'
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg unzip xz-utils \
 && rm -rf /var/lib/apt/lists/*

# Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

# Bun (gestionnaire de paquets rapide)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Installe les deps (cache-friendly)
COPY package.json bun.lockb* ./
RUN bun install || true

# Code
COPY . .

EXPOSE 3333
CMD ["bash", "-lc", "node ace serve --watch"]
EOF

# docker-compose (hot reload + bind mount)
cat > "$APP_DIR/docker-compose.yml" <<'EOF'
services:
  adonis:
    build: .
    container_name: adonis-hello
    ports:
      - "3333:3333"
    volumes:
      - .:/app
    command: ["bash", "-lc", "bun install && node ace serve --watch"]
    restart: unless-stopped
EOF

echo
echo "✅ Projet prêt."
echo "   cd $PROJECT_NAME"
echo "   docker compose up"
echo "➡ http://localhost:3333 → Hello World 👋"
