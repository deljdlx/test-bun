# ---- base : Debian + Bun ----
FROM debian:bookworm-slim AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates unzip xz-utils

RUN apt-get install -y \
  build-essential python3 pkg-config libsqlite3-dev

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL https://bun.sh/install | bash
# ENV PATH="/root/.bun/bin:${PATH}"

FROM base AS dev

# --- runtime user & workspace ---
RUN useradd -m -u 1000 bun && mkdir -p /app && chown bun:bun /app
USER bun

# Installer Bun DANS le home du user bun
ENV BUN_INSTALL=/home/bun/.bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="${BUN_INSTALL}/bin:${PATH}"


WORKDIR /app
EXPOSE 3333


# infinite tail - keep container running
CMD ["tail", "-f", "/dev/null"]

