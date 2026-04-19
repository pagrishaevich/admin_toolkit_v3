#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

require_root
require_command getent

if ! getent hosts "$DOMAIN"; then
  log "[DOMAIN] DNS ERROR"
  exit 1
fi

HOSTNAME="$(hostname)"

if realm list 2>/dev/null | grep -Fq "$DOMAIN"; then
  log "[DOMAIN] already joined"
  exit 0
fi

if command -v join-to-domain.sh >/dev/null 2>&1; then
  join-to-domain.sh -d "$DOMAIN" -n "$HOSTNAME" -u "$DOMAIN_USER" -y -f
else
  require_command realm
  realm join "$DOMAIN" -U "$DOMAIN_USER"
fi

if command_exists systemctl; then
  systemctl restart sssd || true
fi

log "[DOMAIN] done"
