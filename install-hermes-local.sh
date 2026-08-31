#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PAKET="$SCRIPT_DIR/hermes-agent_0.20.6+termux2_aarch64.deb"
EXPECTED_SHA256="4e87ebff34c92498b8fe7474a0d74d7aa8e34d0cc02ccc5df8fab2cca3e417af"

echo "==> Cek paket .deb"
if [ ! -f "$PAKET" ]; then
  echo "Paket tidak ada, download dari GitHub Release..."
  if command -v gh >/dev/null 2>&1; then
    gh release download v0.20.6-hermes -R encydu/hermes-termux-setup --pattern '*.deb' -D "$SCRIPT_DIR"
  else
    curl -fSL --retry 3 "https://github.com/encydu/hermes-termux-setup/releases/download/v0.20.6-hermes/hermes-agent_0.20.6+termux2_aarch64.deb" -o "$PAKET"
  fi
fi
if [ ! -f "$PAKET" ]; then
  echo "ERROR: paket belum ada." >&2
  exit 1
fi

echo "==> Verifikasi checksum"
actual="$(sha256sum "$PAKET" | awk '{print $1}')"
if [ "$actual" != "$EXPECTED_SHA256" ]; then
  echo "Checksum mismatch: $actual" >&2
  exit 1
fi
echo "Checksum OK."

echo "==> Install dependensi"
pkg install -y bash ca-certificates coreutils curl dpkg git gdbm \
               ncurses openssl readline ripgrep zlib >/dev/null
pkg install -y --no-auto-upgrade python >/dev/null 2>&1 || true

echo "==> Pasang Hermes"
dpkg -i "$PAKET" 2>&1 || {
  echo "Perbaiki dependensi..."
  apt-get -f install -y
  dpkg -i "$PAKET"
}

echo ""
echo "Selesai. Cek:  hermes --version"
