#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/kaspersky.sh"
source "$(dirname "$0")/cryptopro.sh"
source "$(dirname "$0")/vipnet.sh"
run_local_hook software
log "[SOFT] done"
