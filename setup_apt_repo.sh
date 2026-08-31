#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
#  setup_apt_repo.sh — Tambahkan repo AdyBag (native Termux) ke APT local
#  Baca signing key dari file lokal di repo ini, BUKAN curl dari luar.
#  Jalankan:  bash setup_apt_repo.sh
# ============================================================================
set -Eeuo pipefail

REPO_URL="${ADYBAG_TERMUX_REPO_URL:-http://144.21.61.111/termux}"
EXPECTED_FINGERPRINT="EAD24A2124EFA7393A78B7B14699F966313F7A6B"
# KEY_URL dihapus — kita pakai file lokal apt/repo-signing-key.asc
KEY_FILE="$(dirname "$(readlink -f "$0")")/apt/repo-signing-key.asc"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
KEYRING_DIR="$PREFIX/etc/apt/keyrings"
KEYRING="$KEYRING_DIR/adybag-termux.gpg"
SOURCE="$PREFIX/etc/apt/sources.list.d/adybag-termux.list"

echo "Installing signed AdyBag native Termux repository..."
pkg install -y ca-certificates curl gnupg >/dev/null
mkdir -p "$KEYRING_DIR" "$(dirname "$SOURCE")"

# verifikasi fingerprint dari file lokal, bukan download
actual="$(gpg --batch --with-colons --show-keys "$KEY_FILE" | awk -F: '$1=="fpr" {print $10; exit}')"
if [ "$actual" != "$EXPECTED_FINGERPRINT" ]; then
  echo "Repository signing-key fingerprint mismatch: $actual" >&2
  exit 1
fi

gpg --batch --yes --dearmor --output "$KEYRING" "$KEY_FILE"
printf 'deb [signed-by=%s] %s stable main\n' "$KEYRING" "$REPO_URL" > "$SOURCE"

apt -o Acquire::Retries=5 -o Acquire::http::Timeout=30 update
cat <<EOF
Repository enabled and signature verified.
Signing fingerprint: $EXPECTED_FINGERPRINT

Examples:
  pkg install hermes-agent
  pkg install uv
EOF
