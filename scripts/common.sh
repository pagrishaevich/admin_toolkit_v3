#!/bin/bash

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$COMMON_DIR/.." && pwd)"

CONFIG_FILE="${BOOTSTRAP_CONFIG:-$PROJECT_ROOT/config.sh}"
CONFIG_EXAMPLE_FILE="$PROJECT_ROOT/config.sh.example"

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
elif [ -f "$CONFIG_EXAMPLE_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_EXAMPLE_FILE"
fi

: "${DOMAIN:=yg.loc}"
: "${DOMAIN_USER:=AGPetrosyan}"
: "${DNS_SERVERS:=10.14.100.222 10.17.101.222}"
: "${NTP_SERVER:=time.yanao.ru}"
: "${PROXY:=10.82.200.1:8090}"
: "${ROLE:=workstation}"
: "${ADMIN_USB_SERIAL:=CHANGE_ME}"
: "${REPORTS_DIR:=/mnt/inv/AGPetrosyan/reports}"
: "${CIFS_SERVER:=10.82.107.5}"
: "${REPO_DIR:=/opt/admin_toolkit}"
: "${AUTO_UPDATE_REMOTE:=origin}"
: "${AUTO_UPDATE_BRANCH:=main}"
: "${DNF_PROXY_CONFIG:=/etc/dnf/dnf.conf}"
: "${TOOLKIT_LOG_FILE:=/var/log/bootstrap.log}"
: "${REPORT_ARCHIVE_DIR:=/var/log/bootstrap_reports}"
: "${CUSTOM_DIR:=$PROJECT_ROOT/custom}"

log() {
  local msg
  msg="[$(date '+%F %T')] $*"
  echo "$msg"
  logger -t BOOTSTRAP "$msg"
}

require_root() {
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    log "[ERROR] run as root"
    exit 1
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  if ! command_exists "$1"; then
    log "[ERROR] missing command: $1"
    exit 1
  fi
}

append_if_missing() {
  local line="$1"
  local file="$2"

  touch "$file"
  grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

replace_or_append_kv() {
  local key="$1"
  local value="$2"
  local file="$3"

  touch "$file"

  if grep -Eq "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

run_local_hook() {
  local hook_name="$1"
  local hook_file="$CUSTOM_DIR/${hook_name}.local.sh"

  if [ -f "$hook_file" ]; then
    log "[HOOK] running $hook_file"
    # shellcheck source=/dev/null
    source "$hook_file"
  else
    log "[HOOK] skipped: $hook_file not found"
  fi
}
