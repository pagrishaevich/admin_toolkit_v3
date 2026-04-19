#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

FAIL=0

realm list | grep -q "$DOMAIN" && log "DOMAIN OK" || { log "DOMAIN FAIL"; FAIL=1; }
mount | grep -Fq "$CIFS_SERVER" && log "CIFS OK" || { log "CIFS FAIL"; FAIL=1; }
systemctl is-active chronyd >/dev/null && log "TIME OK" || { log "TIME FAIL"; FAIL=1; }
systemctl is-enabled dnf-automatic.timer >/dev/null && log "AUTOUPDATE OK" || { log "AUTOUPDATE FAIL"; FAIL=1; }

if [ "$FAIL" -eq 0 ]; then
  log "[RESULT] SUCCESS"
else
  log "[RESULT] FAIL"
  exit 1
fi
