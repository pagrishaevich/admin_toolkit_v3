#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
require_command systemctl
run_cmd systemctl enable --now chronyd
log "[TIME] done"
