#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

: "${VIPNET_ENABLED:=0}"
: "${VIPNET_DIST_DIR:=/mnt/distr/linux/bootstrap/vipnet}"
: "${VIPNET_ARCHIVE_PATTERN:=ViPNet*.zip}"
: "${VIPNET_VARIANT:=gui}"

find_single_file_anydepth() {
  local search_dir="$1"
  local pattern="$2"

  find "$search_dir" -type f -name "$pattern" | sort | tail -n 1
}

install_vipnet() {
  local archive_path=""
  local extract_dir=""
  local search_root=""
  local vipnet_rpm=""

  if [ "$VIPNET_ENABLED" != "1" ]; then
    log "[VIPNET] skipped"
    return 0
  fi

  require_root
  require_command dnf

  if [ ! -d "$VIPNET_DIST_DIR" ]; then
    log "[ERROR] VIPNET_DIST_DIR does not exist: $VIPNET_DIST_DIR"
    exit 1
  fi

  case "$VIPNET_VARIANT" in
    gui|cli)
      ;;
    *)
      log "[ERROR] VIPNET_VARIANT must be gui or cli"
      exit 1
      ;;
  esac

  search_root="$VIPNET_DIST_DIR"

  if [ "$VIPNET_VARIANT" = "gui" ]; then
    vipnet_rpm="$(find_single_file_anydepth "$search_root" 'vipnetclient-gui*_x86-64_*.rpm')"
  else
    vipnet_rpm="$(find_single_file_anydepth "$search_root" 'vipnetclient*_x86-64_*.rpm')"
    if [ -n "$vipnet_rpm" ] && printf '%s\n' "$vipnet_rpm" | grep -Fq 'vipnetclient-gui'; then
      vipnet_rpm=""
    fi
  fi

  archive_path="$(find_single_file "$VIPNET_DIST_DIR" "$VIPNET_ARCHIVE_PATTERN")"
  if [ -n "$archive_path" ]; then
    log "[VIPNET] found archive: $archive_path"
  fi

  if [ -z "$vipnet_rpm" ] && [ -n "$archive_path" ]; then
    if [ "$DRY_RUN" = "1" ]; then
      log "[DRY-RUN] unpack ViPNet archive: $archive_path"
    else
      require_command unzip
      extract_dir="$(mktemp -d /tmp/vipnet.XXXXXX)"
      unzip -q "$archive_path" -d "$extract_dir"
      search_root="$extract_dir"
      log "[VIPNET] unpacked archive to: $search_root"
    fi
  fi

  if [ -z "$vipnet_rpm" ]; then
    if [ "$VIPNET_VARIANT" = "gui" ]; then
      vipnet_rpm="$(find_single_file_anydepth "$search_root" 'vipnetclient-gui*_x86-64_*.rpm')"
    else
      vipnet_rpm="$(find_single_file_anydepth "$search_root" 'vipnetclient*_x86-64_*.rpm')"
      if [ -n "$vipnet_rpm" ] && printf '%s\n' "$vipnet_rpm" | grep -Fq 'vipnetclient-gui'; then
        vipnet_rpm=""
      fi
    fi
  fi

  if [ -z "$vipnet_rpm" ]; then
    if [ -n "$extract_dir" ]; then
      rm -rf "$extract_dir"
    fi
    log "[ERROR] ViPNet RPM not found for variant ${VIPNET_VARIANT} in $VIPNET_DIST_DIR"
    exit 1
  fi

  log "[VIPNET] selected RPM: $vipnet_rpm"
  log "[VIPNET] installing ViPNet Client (${VIPNET_VARIANT})"
  run_cmd dnf install -y "$vipnet_rpm"

  if [ -n "$extract_dir" ] && [ -d "$extract_dir" ]; then
    rm -rf "$extract_dir"
  fi

  log "[VIPNET] keys installation skipped by design"
  log "[VIPNET] done"
}

install_vipnet "$@"
