#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
#  install-hermes-local.sh — Install Hermes Agent dari paket .deb yang
#  di-re-host ke repo GitHub kita sendiri (self-contained, bukan adybag).
#
#  Jalankan:  bash install-hermes-local.sh
# ============================================================================
set -Eeuo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PAKET="$SCRIPT_DIR/hermes-agent_0.20.6+termux2_aarch64.deb"
EXPECTED_SHA256="4e87ebff34c92498b8fe7474a0d74d7aa8e34d0cc02ccc5df8fab2cca3e417af"

echo "==> Cek paket .deb yang di-bundle di repo ini..."
if [ ! -f "$PAKET" ]; then
  echo "Paket tidak ditemukan di $PAKET"
  echo "Download dari GitHub Release repo ini:"
  echo "  gh release download v0.20.6-hermes -R encydu/hermes-termux-setup"
  # Otomatis download kalau ada gh
  if command -v gh >/dev/null 2>&1; then
    gh release download v0.20.6-hermes -R encydu/hermes-termux-setup --pattern '*.deb' -D "$SCRIPT_DIR"
  else
    curl -fSL --retry 3 "https://github.com/encydu/hermes-termux-setup/releases/download/v0.20.6-hermes/hermes-agent_0.20.6+termux2_aarch64.deb" -o "$PAKET"
  fi
fi
if [ ! -f "$PAKET" ]; then
  echo "ERROR: masih belum ada paket. Hentikan." >&2
  exit 1
fi

echo "==> Verifikasi checksum SHA256..."
actual="$(sha256sum "$PAKET" | awk '{print $1}')"
if [ "$actual" != "$EXPECTED_SHA256" ]; then
  echo "Checksum mismatch: $actual (expected $EXPECTED_SHA256)" >&2
  exit 1
fi
echo "Checksum OK."

echo "==> Install dependensi dasar + paket Hermes lokal (dpkg)..."
pkg install -y bash ca-certificates coreutils curl dpkg git gdbm \
               ncurses openssl readline ripgrep zlib >/dev/null
pkg install -y --no-auto-upgrade python 2>/dev/null || true

echo "==> Pasang paket .deb Hermes (native aarch64)..."
dpkg -i "$PAKET" 2>&1 || {
  echo "dpkg butuh dependensi; coba perbaiki dengan apt-get -f install..."
  apt-get -f install -y
  dpkg -i "$PAKET"
}

echo ""
echo "============================================================"
echo "  Hermes Agent (local .deb) terpasang."
echo "  Cek:  hermes --version"
echo "============================================================"
