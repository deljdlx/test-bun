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
EXPOSE 3333
# surchargé par docker-compose (bun --watch), mais laisse un défaut correct
# CMD ["bun", "run", "adonisjs/index.ts"]

# infinite tail - keep container running
CMD ["tail", "-f", "/dev/null"]

