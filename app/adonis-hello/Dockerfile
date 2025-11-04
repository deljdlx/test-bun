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
