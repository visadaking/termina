#!/usr/bin/env bash
set -euo pipefail

# Checks whether the AMDGPU RA24 (DRM_FORMAT_RGBA8888) workaround is still needed.
# Upstream: https://gitlab.freedesktop.org/drm/amd/-/work_items/5339
#
# Exit codes:
#   0 - no RA24 problem detected / looks fixed
#   1 - RA24 problem or workaround still needed
#   2 - could not determine

RED=$'\033[31m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RESET=$'\033[0m'

status=0
warn() { printf '%s[WARN]%s %s\n' "$YELLOW" "$RESET" "$*"; }
bad()  { printf '%s[BAD]%s  %s\n' "$RED" "$RESET" "$*"; status=1; }
good() { printf '%s[OK]%s   %s\n' "$GREEN" "$RESET" "$*"; }
info() { printf '[..]  %s\n' "$*"; }

info "Checking AMDGPU RA24 / DRM_FORMAT_RGBA8888 workaround status"
info "Upstream: https://gitlab.freedesktop.org/drm/amd/-/work_items/5339"
echo

# 1) Kernel log symptoms in current boot
if journalctl -b --no-pager -g 'Unsupported screen format RA24|RGBA8888.*0x34324152' -q 2>/dev/null | grep -q .; then
  bad "Current boot has RA24 format errors in journalctl."
else
  good "No RA24 format errors found in current boot journal."
fi

# 2) Debugfs plane format advertisement (needs root/debugfs mounted)
ra24_advertised=""
for state in /sys/kernel/debug/dri/card*/state; do
  [ -r "$state" ] || continue
  if grep -q 'RGBA8888\|RA24' "$state" 2>/dev/null; then
    ra24_advertised+="$state "
  fi
done
if [ -n "$ra24_advertised" ]; then
  bad "RA24/RGBA8888 appears in DRM debugfs state: $ra24_advertised"
  info "If the proper DC fix is present, this may be expected; confirm atomic commits work."
elif [ -d /sys/kernel/debug/dri ]; then
  if ls /sys/kernel/debug/dri/card*/state >/dev/null 2>&1; then
    good "RA24/RGBA8888 not found in readable DRM debugfs state files."
  else
    warn "DRM debugfs state files not readable; run as root for a fuller check."
    [ "$status" -eq 0 ] && status=2
  fi
else
  warn "debugfs DRM state not available; cannot inspect advertised plane formats."
  [ "$status" -eq 0 ] && status=2
fi

# 3) Local workaround presence
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/.." && pwd)
if grep -Rqn 'amdgpu-ra24-fix\|DRM_FORMAT_RGBA8888' "$repo_root/modules" "$repo_root/patches" 2>/dev/null; then
  warn "Local RA24 workaround/patch appears present in repo: $repo_root"
else
  info "No local RA24 workaround markers found in $repo_root/modules or $repo_root/patches."
fi

# 4) Optional upstream issue status (best effort; may be blocked by Anubis)
issue_url="https://gitlab.freedesktop.org/api/v4/projects/drm%2Famd/issues/5339"
if command -v curl >/dev/null 2>&1; then
  issue_json=$(curl -fsS --max-time 8 "$issue_url" 2>/dev/null || true)
  if [ -n "$issue_json" ]; then
    issue_state=$(printf '%s' "$issue_json" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p' | head -n1)
    issue_title=$(printf '%s' "$issue_json" | sed -n 's/.*"title":"\([^"]*\)".*/\1/p' | head -n1)
    if [ -n "$issue_state" ]; then
      info "Upstream issue state: $issue_state${issue_title:+ - $issue_title}"
      if [ "$issue_state" = "closed" ]; then
        warn "Upstream issue is closed; check if your kernel includes the fix, then remove local workaround."
        [ "$status" -eq 0 ] && status=1
      fi
    else
      warn "Could not parse upstream issue state (API response unexpected)."
    fi
  else
    warn "Could not query upstream issue (network/Anubis/API). Check manually: https://gitlab.freedesktop.org/drm/amd/-/work_items/5339"
  fi
else
  warn "curl not found; skipping upstream issue check."
fi

echo
case "$status" in
  0) good "No active RA24 problem detected. Verify before removing workaround." ;;
  1) bad  "RA24 workaround still looks needed, or upstream is fixed and local cleanup is pending." ;;
  2) warn "Inconclusive. Run with sudo and/or check upstream manually." ;;
esac
exit "$status"
