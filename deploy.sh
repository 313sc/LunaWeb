#!/bin/bash
set -e

PROJECT_DIR="/opt/LunaWeb"
REPO_URL="https://github.com/313sc/LunaWeb"
PORT=313
APP_NAME="LunaWeb"

echo "=========================================="
echo "  LunaWeb Deployment Script"
echo "  Port: $PORT"
echo "=========================================="

if command -v node &> /dev/null; then
    echo "[OK] Node.js is installed"
    node --version
else
    echo "[ERROR] Node.js is not installed. Please install Node.js first."
    exit 1
fi

if command -v npm &> /dev/null; then
    echo "[OK] npm is installed"
    npm --version
else
    echo "[ERROR] npm is not installed."
    exit 1
fi

if ! command -v pm2 &> /dev/null; then
    echo "[INFO] PM2 not found. Installing..."
    sudo npm install -g pm2
else
    echo "[OK] PM2 is installed"
    pm2 --version
fi

echo ""
echo "1. Checking project directory..."

if [ -d "$PROJECT_DIR" ]; then
    echo "[INFO] Project directory exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull origin main
else
    echo "[INFO] Project directory does not exist. Cloning repository..."
    sudo git clone "$REPO_URL" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi

echo ""
echo "2. Installing dependencies..."
npm install

echo ""
echo "3. Building project..."
npm run build

echo ""
echo "4. Stopping existing process..."
pm2 delete "$APP_NAME" 2>/dev/null || true

echo ""
echo "5. Starting server with PM2 using ecosystem config..."
pm2 start ecosystem.config.js

echo ""
echo "6. Saving PM2 process list..."
pm2 save
pm2 startup systemd -u root --hp /root

echo ""
echo "=========================================="
echo "  Deployment successful!"
echo "  App: $APP_NAME"
echo "  Port: $PORT"
echo "  URL: http://localhost:$PORT"
echo ""
echo "  PM2 commands:"
echo "    pm2 status          - Check status"
echo "    pm2 logs $APP_NAME  - View logs"
echo "    pm2 restart $APP_NAME - Restart app"
echo "    pm2 stop $APP_NAME  - Stop app"
echo "=========================================="

pm2 status