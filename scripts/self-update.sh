#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

log "[UPDATE] checking..."

if [ ! -d "$REPO_DIR/.git" ]; then
  log "[UPDATE] not git repo"
  exit 0
fi

require_command git

cd "$REPO_DIR"

if [ "$DRY_RUN" = "1" ]; then
  log "[DRY-RUN] git fetch $AUTO_UPDATE_REMOTE"
  log "[UPDATE] dry-run skipped remote revision comparison"
  exit 0
fi

run_cmd git fetch "$AUTO_UPDATE_REMOTE"

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "$AUTO_UPDATE_REMOTE/$AUTO_UPDATE_BRANCH")

if [ "$LOCAL" != "$REMOTE" ]; then
  log "[UPDATE] new revision detected in $REPO_DIR"
  log "[UPDATE] restart bootstrap after syncing the working copy"
else
  log "[UPDATE] up to date"
fi
