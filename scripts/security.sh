#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root

configure_firewall() {
  local service
  local port

  if [ "$FIREWALL_ENABLED" != "1" ]; then
    log "[FIREWALL] skipped by config"
    return 0
  fi

  if ! command_exists firewall-cmd; then
    log "[FIREWALL] skipped: firewall-cmd not found"
    return 0
  fi

  run_cmd systemctl enable --now firewalld

  for service in $FIREWALL_SERVICES; do
    run_cmd firewall-cmd --permanent --add-service="$service"
  done

  for port in $FIREWALL_PORTS; do
    run_cmd firewall-cmd --permanent --add-port="$port"
  done

  run_cmd firewall-cmd --reload
  log "[FIREWALL] done"
}

configure_sshd() {
  if [ "$SSHD_HARDENING_ENABLED" != "1" ]; then
    log "[SSHD] skipped by config"
    return 0
  fi

  if [ ! -f "$SSH_CONFIG_FILE" ]; then
    log "[SSHD] skipped: config not found"
    return 0
  fi

  backup_file "$SSH_CONFIG_FILE"
  replace_or_append_setting PermitRootLogin "$SSHD_PERMIT_ROOT_LOGIN" "$SSH_CONFIG_FILE"
  replace_or_append_setting PasswordAuthentication "$SSHD_PASSWORD_AUTH" "$SSH_CONFIG_FILE"

  if command_exists systemctl; then
    run_cmd systemctl reload sshd || run_cmd systemctl reload ssh || true
  fi

  log "[SSHD] done"
}

if [ "$ADMIN_USB_SERIAL" = "CHANGE_ME" ]; then
  log "[USB] skipped: ADMIN_USB_SERIAL is not configured"
else
  log "[USB] TODO: implement USB policy for serial $ADMIN_USB_SERIAL"
fi

configure_firewall
configure_sshd

run_local_hook security
log "[SECURITY] done"
