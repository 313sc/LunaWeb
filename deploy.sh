#!/bin/bash

PROJECT_DIR="/opt/LunaWeb"
REPO_URL="https://github.com/313sc/LunaWeb"
PORT=313

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

echo ""
echo "1. Checking project directory..."

if [ -d "$PROJECT_DIR" ]; then
    echo "[INFO] Project directory exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull origin main
else
    echo "[INFO] Project directory does not exist. Cloning repository..."
    git clone "$REPO_URL" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi

echo ""
echo "2. Installing dependencies..."
npm install

echo ""
echo "3. Building project..."
npm run build

echo ""
echo "4. Installing serve globally..."
npm install -g serve

echo ""
echo "5. Stopping existing process on port $PORT..."
PID=$(lsof -ti:$PORT)
if [ -n "$PID" ]; then
    echo "[INFO] Killing process $PID"
    kill -9 "$PID" 2>/dev/null || true
    sleep 2
fi

echo ""
echo "6. Starting server on port $PORT..."
nohup serve -l "$PORT" -s dist > /var/log/lunaweb.log 2>&1 &

sleep 3

if lsof -Pi:$PORT -sTCP:LISTEN -t > /dev/null ; then
    echo ""
    echo "=========================================="
    echo "  Deployment successful!"
    echo "  Server running on: http://localhost:$PORT"
    echo "  Log file: /var/log/lunaweb.log"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "  [ERROR] Failed to start server!"
    echo "  Check log file: /var/log/lunaweb.log"
    echo "=========================================="
    exit 1
fi