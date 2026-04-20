#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_DIR="/root/.bootstrap"

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  echo "[install-host] run as root" >&2
  exit 1
fi

mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"

if [ ! -f "$SECRETS_DIR/domain.pass" ]; then
  echo "[install-host] missing $SECRETS_DIR/domain.pass" >&2
  exit 1
fi

if [ ! -f "$SECRETS_DIR/cifs.pass" ]; then
  echo "[install-host] missing $SECRETS_DIR/cifs.pass" >&2
  exit 1
fi

chmod 600 "$SECRETS_DIR/domain.pass" "$SECRETS_DIR/cifs.pass"

# shellcheck source=/dev/null
source "$ROOT_DIR/scripts/common.sh"

find_required_file() {
  local search_dir="$1"
  local pattern="$2"

  find "$search_dir" -type f -name "$pattern" | grep -q .
}

check_dir() {
  local dir_path="$1"
  local label="$2"

  if [ ! -d "$dir_path" ]; then
    echo "[install-host] missing ${label} directory: $dir_path" >&2
    exit 1
  fi
}

if [ "${KASPERSKY_ENABLED:-0}" = "1" ]; then
  check_dir "$KASPERSKY_SHARE_DIR" "Kaspersky"
  find_required_file "$KASPERSKY_SHARE_DIR" 'kesl-[0-9]*.rpm' || {
    echo "[install-host] missing Kaspersky package kesl-*.rpm in $KASPERSKY_SHARE_DIR" >&2
    exit 1
  }
  if [ "${KASPERSKY_INSTALL_NETWORK_AGENT:-0}" = "1" ]; then
    find_required_file "$KASPERSKY_SHARE_DIR" 'klnagent64-*.rpm' || {
      echo "[install-host] missing Kaspersky agent package klnagent64-*.rpm in $KASPERSKY_SHARE_DIR" >&2
      exit 1
    }
  fi
fi

if [ "${CRYPTO_PRO_ENABLED:-0}" = "1" ]; then
  check_dir "$CRYPTO_PRO_DIST_DIR" "CryptoPro"
  if ! find_required_file "$CRYPTO_PRO_DIST_DIR" "$CRYPTO_PRO_ARCHIVE_PATTERN" &&
     ! find_required_file "$CRYPTO_PRO_DIST_DIR" 'lsb-cprocsp-base-*.rpm'; then
    echo "[install-host] missing CryptoPro archive or RPM packages in $CRYPTO_PRO_DIST_DIR" >&2
    exit 1
  fi
  if [ "${CRYPTO_PRO_INSTALL_RUTOKEN_PKCS11:-0}" = "1" ]; then
    find_required_file "$CRYPTO_PRO_DIST_DIR" 'librtpkcs11ecp-*.rpm' || {
      echo "[install-host] missing Rutoken PKCS#11 package librtpkcs11ecp-*.rpm in $CRYPTO_PRO_DIST_DIR" >&2
      exit 1
    }
  fi
fi

if [ "${VIPNET_ENABLED:-0}" = "1" ]; then
  check_dir "$VIPNET_DIST_DIR" "ViPNet"
  if ! find_required_file "$VIPNET_DIST_DIR" "$VIPNET_ARCHIVE_PATTERN" &&
     ! find_required_file "$VIPNET_DIST_DIR" 'vipnetclient-gui*_x86-64_*.rpm' &&
     ! find_required_file "$VIPNET_DIST_DIR" 'vipnetclient*_x86-64_*.rpm'; then
    echo "[install-host] missing ViPNet archive or RPM packages in $VIPNET_DIST_DIR" >&2
    exit 1
  fi
fi

if [ "${YANDEX_BROWSER_ENABLED:-0}" = "1" ] || [ "${R7_OFFICE_ENABLED:-0}" = "1" ]; then
  if ! command -v dnf >/dev/null 2>&1; then
    echo "[install-host] missing dnf for repository package installation" >&2
    exit 1
  fi
fi

exec bash "$ROOT_DIR/scripts/bootstrap.sh"
