#!/bin/bash
set -e

PROJECT_DIR="/opt/LunaWeb"
REPO_URL="https://github.com/313sc/LunaWeb"
PORT=313
APP_NAME="LunaWeb"
LOG_DIR="/var/log"

echo "=========================================="
echo "  LunaWeb Deployment Script"
echo "  Port: $PORT"
echo "=========================================="

if command -v node &> /dev/null; then
    echo "[OK] Node.js is installed"
    NODE_VERSION=$(node --version)
    echo "[INFO] Node.js version: $NODE_VERSION"
else
    echo "[ERROR] Node.js is not installed. Please install Node.js first."
    exit 1
fi

if command -v npm &> /dev/null; then
    echo "[OK] npm is installed"
    NPM_VERSION=$(npm --version)
    echo "[INFO] npm version: $NPM_VERSION"
else
    echo "[ERROR] npm is not installed."
    exit 1
fi

if ! command -v pm2 &> /dev/null; then
    echo "[INFO] PM2 not found. Installing..."
    sudo npm install -g pm2
else
    echo "[OK] PM2 is installed"
    PM2_VERSION=$(pm2 --version)
    echo "[INFO] PM2 version: $PM2_VERSION"
fi

echo ""
echo "1. Creating log directory..."
if [ ! -d "$LOG_DIR" ]; then
    sudo mkdir -p "$LOG_DIR"
    echo "[INFO] Created log directory: $LOG_DIR"
else
    echo "[OK] Log directory exists: $LOG_DIR"
fi

echo ""
echo "2. Configuring firewall (ufw)..."
if command -v ufw &> /dev/null; then
    if ! sudo ufw status | grep -q "active"; then
        echo "[INFO] Enabling ufw firewall..."
        sudo ufw enable
    fi
    
    if ! sudo ufw status | grep -q "$PORT"; then
        echo "[INFO] Allowing port $PORT through firewall..."
        sudo ufw allow "$PORT"
        echo "[OK] Port $PORT allowed"
    else
        echo "[OK] Port $PORT already allowed"
    fi
else
    echo "[INFO] ufw not installed, skipping firewall configuration"
fi

echo ""
echo "3. Checking project directory..."

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
echo "4. Installing dependencies..."
npm install --production

echo ""
echo "5. Building project..."
npm run build

echo ""
echo "6. Stopping existing process..."
pm2 delete "$APP_NAME" 2>/dev/null || true

echo ""
echo "7. Starting server with PM2 using ecosystem config..."
pm2 start ecosystem.config.js

echo ""
echo "8. Saving PM2 process list..."
pm2 save

echo ""
echo "9. Configuring PM2 startup on boot..."
pm2 startup systemd -u root --hp /root 2>/dev/null || true

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
echo "    pm2 delete $APP_NAME - Delete app"
echo "=========================================="

pm2 status