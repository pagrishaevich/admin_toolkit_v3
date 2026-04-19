#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
require_command mount
mkdir -p /mnt/inv /mnt/distr "$REPORTS_DIR"

if mount | grep -Fq "$CIFS_SERVER"; then
  log "[CIFS] already mounted"
else
  mount -a
fi

log "[CIFS] done"
