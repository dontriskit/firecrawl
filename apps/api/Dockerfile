FROM node:22-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install && pnpm run build

# Install Go - ARM compatible
FROM golang:1.24-bullseye AS go-base
COPY sharedLibs/go-html-to-md /app/sharedLibs/go-html-to-md

# Install Go dependencies and build parser lib - with GOARCH specified for ARM
RUN cd /app/sharedLibs/go-html-to-md && \
    go mod tidy && \
    GOARCH=arm64 go build -o html-to-markdown.so -buildmode=c-shared html-to-markdown.go && \
    chmod +x html-to-markdown.so

# Install Rust - ARM compatible
FROM rust:1-slim-bullseye AS rust-base
COPY sharedLibs/html-transformer /app/sharedLibs/html-transformer

# Install additional build tools needed for Rust on ARM
RUN apt-get update && apt-get install -y build-essential pkg-config libssl-dev

# Build transformer lib with target for ARM
RUN cd /app/sharedLibs/html-transformer && \
    rustup target add aarch64-unknown-linux-gnu && \
    cargo build --release --target aarch64-unknown-linux-gnu && \
    cp target/aarch64-unknown-linux-gnu/release/libhtml_transformer.so target/release/ && \
    chmod +x target/release/libhtml_transformer.so

FROM base
COPY --from=build /app/dist /app/dist
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=go-base /app/sharedLibs/go-html-to-md/html-to-markdown.so /app/sharedLibs/go-html-to-md/html-to-markdown.so
COPY --from=rust-base /app/sharedLibs/html-transformer/target/release/libhtml_transformer.so /app/sharedLibs/html-transformer/target/release/libhtml_transformer.so

# Install git and additional dependencies for ARM
RUN apt-get update && apt-get install -y git build-essential python3 && rm -rf /var/lib/apt/lists/*

# Make docker-entrypoint.sh executable and fix line endings
RUN chmod +x /app/docker-entrypoint.sh && \
    sed -i 's/\r$//' /app/docker-entrypoint.sh

# Expose port and set entrypoint
EXPOSE 3002

ENTRYPOINT ["/app/docker-entrypoint.sh"]