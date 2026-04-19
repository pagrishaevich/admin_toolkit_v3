#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
require_command systemctl
run_cmd systemctl enable --now dnf-automatic.timer
log "[AUTOUPDATE] done"
