#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_root
export http_proxy="$PROXY"
export https_proxy="$PROXY"
replace_or_append_kv proxy "http://$PROXY" "$DNF_PROXY_CONFIG"
log "[PROXY] done"
