# ---- base : Debian + Bun ----
FROM debian:bookworm-slim AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates unzip xz-utils \
  && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# ---- dev : pas de COPY, on montera le code en volume ----
FROM base AS dev
WORKDIR /app
EXPOSE 3000
# surchargé par docker-compose (bun --watch), mais laisse un défaut correct
CMD ["bun", "run", "server.ts"]

# ---- prod : on embarque le code dans l'image ----
FROM base AS prod
WORKDIR /app
# Si tu as un package.json/bun.lockb, copie-les d’abord pour tirer parti du cache
# COPY package.json bun.lockb* ./
# RUN test -f package.json && bun install --no-save || true
COPY . .
EXPOSE 3000
CMD ["bun", "run", "server.ts"]
