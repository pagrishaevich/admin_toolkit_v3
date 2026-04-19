#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

if [ "$ADMIN_USB_SERIAL" = "CHANGE_ME" ]; then
  log "[USB] skipped: ADMIN_USB_SERIAL is not configured"
else
  log "[USB] TODO: implement USB policy for serial $ADMIN_USB_SERIAL"
fi

run_local_hook security
log "[SECURITY] done"
