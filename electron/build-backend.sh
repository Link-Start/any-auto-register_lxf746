#!/bin/bash
# 将 Python 后端打包为单文件可执行程序，输出到 electron/backend/
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/../"

cd "$BACKEND_DIR"

echo "[1/3] 安装 PyInstaller..."
pip install pyinstaller --quiet

echo "[2/3] 打包后端..."
pyinstaller --onefile --name backend \
  --add-data "platforms:platforms" \
  --add-data "core:core" \
  --add-data "api:api" \
  --add-data "services:services" \
  --add-data "providers:providers" \
  --add-data "application:application" \
  --add-data "infrastructure:infrastructure" \
  --add-data "domain:domain" \
  --add-data "static:static" \
  --hidden-import uvicorn.logging \
  --hidden-import uvicorn.loops \
  --hidden-import uvicorn.loops.auto \
  --hidden-import uvicorn.protocols \
  --hidden-import uvicorn.protocols.http \
  --hidden-import uvicorn.protocols.http.auto \
  --hidden-import uvicorn.protocols.websockets \
  --hidden-import uvicorn.protocols.websockets.auto \
  --hidden-import uvicorn.lifespan \
  --hidden-import uvicorn.lifespan.on \
  --hidden-import uvicorn.lifespan.off \
  --hidden-import services.turnstile_solver.api_solver \
  --hidden-import services.turnstile_solver.db_results \
  --hidden-import services.turnstile_solver.browser_configs \
  --hidden-import services.turnstile_solver.start \
  --hidden-import quart \
  main.py

echo "[3/3] 复制产物到 electron/backend/"
mkdir -p "$SCRIPT_DIR/backend"
cp dist/backend* "$SCRIPT_DIR/backend/"

echo "完成! 可执行文件: $SCRIPT_DIR/backend/backend"
