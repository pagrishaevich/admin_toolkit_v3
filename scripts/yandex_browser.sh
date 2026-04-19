#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

install_yandex_browser() {
  if [ "$YANDEX_BROWSER_ENABLED" != "1" ]; then
    return 0
  fi

  log "[YANDEX] installing repository package: $YANDEX_BROWSER_RELEASE_PACKAGE"
  run_cmd dnf install -y "$YANDEX_BROWSER_RELEASE_PACKAGE"

  log "[YANDEX] installing browser package: $YANDEX_BROWSER_PACKAGE"
  run_cmd dnf install -y "$YANDEX_BROWSER_PACKAGE"

  log "[YANDEX] done"
}

install_yandex_browser
