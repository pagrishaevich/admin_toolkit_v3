#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "$DIR/common.sh"

require_root

LOCK="/var/run/bootstrap.lock"
exec 9>"$LOCK"
flock -n 9 || { log "[BOOTSTRAP] already running"; exit 1; }

exec > >(tee -a "$TOOLKIT_LOG_FILE") 2>&1

run_step() {
  local step="$1"
  log "[BOOTSTRAP] running $step"
  bash "$DIR/$step.sh"
}

run_step self-update

for f in proxy repos packages network time autoupdate domain cifs report software security; do
  run_step "$f"
done

run_step postcheck

echo "=== FINISHED ==="
