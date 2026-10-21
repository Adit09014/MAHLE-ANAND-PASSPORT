#!/usr/bin/env bash
# ============================================================================
# MAHLE ANAND GROWTH PASSPORT - LINUX SERVER AUTO-START ON REBOOT
# Run with: sudo bash scripts/setup-linux-boot.sh
# ============================================================================
set -e

echo "[1/4] Ensuring PM2 is installed globally..."
npm install -g pm2

echo "[2/4] Starting application with PM2..."
pm2 start ecosystem.config.js

echo "[3/4] Generating systemd startup service..."
pm2 startup systemd -u "$USER" --hp "$HOME"

echo "[4/4] Saving running state so it restores on every reboot..."
pm2 save

echo "============================================================================"
echo "DONE! Application will auto-restart on crashes and start on server reboot."
echo "============================================================================"
