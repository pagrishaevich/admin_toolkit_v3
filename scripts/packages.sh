#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
require_command dnf
run_cmd dnf install -y join-to-domain realmd sssd adcli oddjob oddjob-mkhomedir firewalld
log "[PKG] done"
