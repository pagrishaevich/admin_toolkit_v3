#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
run_local_hook repos
log "[REPOS] done"
