#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LOCAL_INSTALL="$SCRIPT_DIR/install-hermes-local.sh"

echo "==> 1/5 Update repositori Termux"
pkg update -y
pkg upgrade -y

echo "==> 2/5 Install Hermes"
bash "$LOCAL_INSTALL"

echo "==> 3/5 Install 9Router"
pkg install -y nodejs-lts ripgrep ffmpeg curl wget >/dev/null 2>&1 || true
npm install -g 9router

echo "==> 4/5 Auto-config Hermes"
hermes config set model.base_url https://rkmcfny.abc-tunnel.us/v1
hermes config set model.api_key sk-13295da0418e0160-p6ohna-1e6f5e96
hermes config set model.model Enuma
hermes config set model.provider custom

echo "==> 5/5 Nyalakan 9Router"
if ! curl -s http://localhost:20128 >/dev/null 2>&1; then
  nohup 9router >~/.9router.log 2>&1 &
fi
sleep 3

echo ""
echo "============================================================"
echo "  SELESAI."
echo ""
echo "  Masuk Hermes:"
echo "        hermes"
echo ""
echo "  Config sudah ke tunnel + Enuma."
echo "  Pindah ke 9Router (ketik di Hermes):"
echo "        set model ke 9router"
echo ""
echo "  Dashboard 9Router:  http://localhost:20128/dashboard"
echo "============================================================"
