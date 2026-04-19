#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
require_command mount
run_cmd mkdir -p /mnt/inv /mnt/distr "$REPORTS_DIR"

if mount | grep -Fq "$CIFS_SERVER"; then
  log "[CIFS] already mounted"
else
  run_cmd mount -a
fi

log "[CIFS] done"
