#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
#  Hermes + 9Router — Auto-Install & Auto-Config untuk Termux (Android)
#  Jalankan:  bash setup-hermes-9router.sh
#
#  Yang dilakukan:
#    - Install Hermes Agent (jalur resmi Termux)
#    - Install 9Router (router model, global npm)
#    - Auto-set config Hermes ke endpoint tunnel + API key + model Enuma
#      ( jadi Hermes langsung hidup begitu dibuka, tanpa ketik ulang )
# ============================================================================
set -e   # hentikan kalau ada error, jangan lanjut ke tahap yang rusak

echo "==> 1/5 Update repositori Termux"
pkg update -y
pkg upgrade -y

echo "==> 2/5 Install dependensi Hermes + Node (untuk 9Router)"
pkg install -y git python clang rust make pkg-config libffi openssl \
               nodejs-lts ripgrep ffmpeg curl wget
export PATH="$PREFIX/bin:$PATH"

echo "==> 3/5 Install Hermes Agent (jalur resmi Termux)"
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

echo "==> 4/5 Install 9Router (global npm)"
npm install -g 9router

echo "==> 5/5 Auto-config Hermes -> tunnel provider + model Enuma"
hermes config set model.base_url https://rkmcfny.abc-tunnel.us/v1
hermes config set model.api_key sk-13295da0418e0160-p6ohna-1e6f5e96
hermes config set model.model Enuma
hermes config set model.provider custom

echo "==> Nyalakan 9Router di background (dashboard :20128)"
if ! curl -s http://localhost:20128 >/dev/null 2>&1; then
  nohup 9router >~/.9router.log 2>&1 &
fi
sleep 3

echo ""
echo "============================================================"
echo "  SELESAI. Sekarang tinggal:"
echo "============================================================"
echo ""
echo "  Masuk Hermes (mulai dari sini):"
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
