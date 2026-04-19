#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$ROOT_DIR/config.sh"
CONFIG_EXAMPLE_FILE="$ROOT_DIR/config.sh.example"
SECRETS_DIR="/root/.bootstrap"

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  echo "[install-host] run as root" >&2
  exit 1
fi

mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
  cp "$CONFIG_EXAMPLE_FILE" "$CONFIG_FILE"
  echo "[install-host] created config.sh from config.sh.example"
fi

if [ ! -f "$SECRETS_DIR/domain.pass" ]; then
  echo "[install-host] missing $SECRETS_DIR/domain.pass" >&2
  exit 1
fi

if [ ! -f "$SECRETS_DIR/cifs.pass" ]; then
  echo "[install-host] missing $SECRETS_DIR/cifs.pass" >&2
  exit 1
fi

chmod 600 "$SECRETS_DIR/domain.pass" "$SECRETS_DIR/cifs.pass"

exec bash "$ROOT_DIR/scripts/bootstrap.sh"
