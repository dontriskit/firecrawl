FROM node:20-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Install required tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml* ./
COPY apps/api/package.json ./apps/api/

# Install dependencies
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# Copy the rest of the app
COPY . .

# Build the API
RUN cd apps/api && pnpm run build

# Install any additional runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Make docker-entrypoint.sh executable and fix line endings
RUN chmod +x /app/apps/api/docker-entrypoint.sh && \
    sed -i 's/\r$//' /app/apps/api/docker-entrypoint.sh

# Expose the API port
EXPOSE 3002

# Set environment variables
ENV PORT=3002
ENV HOST=0.0.0.0
ENV USE_DB_AUTHENTICATION=false
ENV BULL_AUTH_KEY=CHANGEME
ENV REDIS_URL=redis://localhost:6379
ENV REDIS_RATE_LIMIT_URL=redis://localhost:6379
ENV PLAYWRIGHT_MICROSERVICE_URL=http://localhost:3000/scrape

# Start the API service
CMD ["node", "--max-old-space-size=8192", "apps/api/dist/src/index.js"]