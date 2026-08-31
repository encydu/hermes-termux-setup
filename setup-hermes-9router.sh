#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
#  setup-hermes-9router.sh — Hermes (self-hosted) + 9Router, auto-config
#  Jalankan:  bash setup-hermes-9router.sh
#
#  Semua komponen di-re-host ke repo GitHub kita sendiri (encydu/hermes-termux-setup):
#   - Hermes Agent dari paket .deb di release kita (BUKAN adybag)
#   - Config Hermes auto-set ke tunnel + API key + model Enuma
#   - 9Router via npm
# ============================================================================
set -Eeuo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LOCAL_INSTALL="$SCRIPT_DIR/install-hermes-local.sh"

echo "==> 1/5 Update repositori Termux"
pkg update -y
pkg upgrade -y

echo "==> 2/5 Install Hermes dari .deb lokal (self-hosted, bukan adybag)"
bash "$LOCAL_INSTALL"

echo "==> 3/5 Install 9Router (global npm)"
pkg install -y nodejs-lts ripgrep ffmpeg curl wget 2>/dev/null || true
npm install -g 9router

echo "==> 4/5 Auto-config Hermes -> tunnel provider + model Enuma"
hermes config set model.base_url https://rkmcfny.abc-tunnel.us/v1
hermes config set model.api_key sk-13295da0418e0160-p6ohna-1e6f5e96
hermes config set model.model Enuma
hermes config set model.provider custom

echo "==> 5/5 Nyalakan 9Router di background (dashboard :20128)"
if ! curl -s http://localhost:20128 >/dev/null 2>&1; then
  nohup 9router >~/.9router.log 2>&1 &
fi
sleep 3

echo ""
echo "============================================================"
echo "  SELESAI. Langkah berikut:"
echo "============================================================"
echo ""
echo "  Masuk Hermes:"
echo "        hermes"
echo ""
echo "  Config sudah ke tunnel (base_url + key + Enuma)."
echo "  Kalau mau pindah ke 9Router, ketik di dalam Hermes:"
echo "        set model ke 9router (endpoint http://localhost:20128/v1)"
echo ""
echo "  Dashboard 9Router:  http://localhost:20128/dashboard"
echo "============================================================"
echo "  CATATAN JUJUR:"
echo "   - Di HP, browser-automation & voice lokal TIDAK jalan."
echo "   - Hermes + 9Router bareng bisa boros RAM; lelet? matikan 9Router."
echo "============================================================"
