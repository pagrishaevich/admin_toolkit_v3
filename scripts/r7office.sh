#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

install_r7_package() {
  local package_name="$1"
  local label="$2"

  log "[R7] installing ${label}: $package_name"
  run_cmd dnf install -y "$package_name"
}

install_r7office() {
  if [ "$R7_OFFICE_ENABLED" != "1" ]; then
    return 0
  fi

  log "[R7] installing repository package: $R7_OFFICE_RELEASE_PACKAGE"
  run_cmd dnf install -y "$R7_OFFICE_RELEASE_PACKAGE"

  install_r7_package "$R7_OFFICE_PACKAGE" "office"

  if [ "$R7_ORGANIZER_ENABLED" = "1" ]; then
    install_r7_package "$R7_ORGANIZER_PACKAGE" "organizer"
  fi

  if [ "$R7_GRAFIKA_ENABLED" = "1" ]; then
    install_r7_package "$R7_GRAFIKA_PACKAGE" "grafika"
  fi

  log "[R7] done"
}

install_r7office
