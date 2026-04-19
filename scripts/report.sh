#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

require_root

REPORT="/tmp/$(hostname)_$(date +%F).csv"

HOST=$(hostname)
DATE=$(date +%F)
IP=$(hostname -I | awk '{print $1}')

printf "hostname,date,ip\n" > "$REPORT"
printf "%s,%s,%s\n" "$HOST" "$DATE" "$IP" >> "$REPORT"

mkdir -p "$REPORTS_DIR" "$REPORT_ARCHIVE_DIR"

cp "$REPORT" "$REPORTS_DIR/" || true
cp "$REPORT" "$REPORT_ARCHIVE_DIR/"

log "[REPORT] done"
