FROM node:18-slim

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

COPY . .

# Install additional dependencies for ARM architecture
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    libu2f-udev \
    libvulkan1 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Install Playwright with specific settings for ARM
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN npx playwright install-deps && \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm install playwright && \
    npx playwright install chromium

RUN npm run build

ARG PORT
ENV PORT=${PORT:-3000}

EXPOSE ${PORT}

CMD [ "npm", "start" ]