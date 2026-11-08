#!/usr/bin/env bash
# Read-only helper + optional LOCAL backup for Syncthing migration (termina/NixOS).
# - Prints this machine's device ID (share/scan on your phone to pair) and folder summary.
# - Optionally creates a SENSITIVE backup bundle (includes cert/key/config) in a local
#   staging directory. NEVER commit the backup. Keep keys private.
#
# Usage:
#   ./scripts/export-syncthing-info.sh                  # info only
#   ./scripts/export-syncthing-info.sh --backup [DEST]  # also backup (default: ~/termina-migration-staging/syncthing)
#
# Your phone is paired at the Syncthing device level (by device ID). To keep the phone
# connected after moving to NixOS, restore the SAME Syncthing identity (cert.pem/key.pem)
# + config on the new machine (paths must match), OR re-pair devices and re-share folders.

set -euo pipefail

DO_BACKUP=0
DEST="${HOME}/termina-migration-staging/syncthing"
for a in "${@:-}"; do
  case "$a" in
    --backup) DO_BACKUP=1 ;;
    -h|--help) sed -n '1,30p' "$0"; exit 0 ;;
    *) if [ "$DO_BACKUP" = "1" ]; then DEST="$a"; fi ;;
  esac
done

# find syncthing config dir (NixOS HM/user service often uses ~/.local/state/syncthing; also check ~/.config/syncthing)
CFG=""
for d in "${XDG_STATE_HOME:-$HOME/.local/state}/syncthing" "$HOME/.config/syncthing" "$HOME/.syncthing"; do
  if [ -f "$d/config.xml" ]; then CFG="$d"; break; fi
done
if [ -z "$CFG" ]; then
  echo "error: syncthing config.xml not found (checked state/config dirs)" >&2
  exit 1
fi

say() { printf '==> %s\n' "$*"; }
warn() { printf '!!  %s\n' "$*"; }

say "Syncthing config dir: $CFG"

# local device ID: prefer API, else parse config.xml (defaults/device named PC or self refs), else derive is complex - show parsed IDs
MYID=""
if command -v curl >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
  APIKEY=$(grep -oP '(?<=<apikey>)[^<]+' "$CFG/config.xml" 2>/dev/null || true)
  if [ -n "$APIKEY" ]; then
    MYID=$(curl -fsS -H "X-API-Key: $APIKEY" http://127.0.0.1:8384/rest/system/status 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin).get("myID",""))' 2>/dev/null || true)
  fi
fi
if [ -z "$MYID" ]; then
  # heuristic: device in <defaults><folder><device id=...> is typically the local device
  MYID=$(grep -oP '(?<=<defaults>).*?(?=</defaults>)' "$CFG/config.xml" 2>/dev/null | grep -oP '(?<=device id=")[A-Z2-7-]{63}(?=")' | head -1 || true)
fi

echo
echo "== This machine (local device) =="
if [ -n "$MYID" ]; then
  echo "Device ID: $MYID"
  if command -v qrencode >/dev/null 2>&1; then
    echo "(QR for adding on phone:)"
    qrencode -t ANSIUTF8 "$MYID" || true
  else
    echo "(tip: install 'qrencode' to show a QR: qrencode -t ANSIUTF8 \"\$ID\")"
  fi
else
  warn "could not determine local device ID automatically; check Syncthing UI -> Actions -> Show ID, or $CFG/config.xml"
fi

echo
echo "== Devices in config =="
python3 - <<PY 2>/dev/null || grep -oP '<device id="[^"]+"[^>]*name="[^"]*"' "$CFG/config.xml" | head -20
import xml.etree.ElementTree as ET
t = ET.parse(r'''$CFG/config.xml''').getroot()
for d in t.findall('device'):
    print(f"- {d.get('name','?'):15} {d.get('id','?')}")
PY

echo
echo "== Folders (label -> path) =="
python3 - <<PY 2>/dev/null || true
import xml.etree.ElementTree as ET
t = ET.parse(r'''$CFG/config.xml''').getroot()
for f in t.findall('folder'):
    print(f"- {f.get('label',f.get('id','?'))}: {f.get('path','?')} ({f.get('type','?')})")
PY

echo
echo "== 'Export to phone' / migration notes =="
echo "- If your phone is already paired (listed above), it stays paired as long as this PC keeps the SAME device identity."
echo "- On the new NixOS (termina) install: to keep identity + config, restore $CFG contents (cert.pem, key.pem, config.xml, https-*)."
echo "  key.pem/cert.pem/config.xml are SENSITIVE - transfer via a secure channel, NEVER commit to git."
echo "- Folder paths in config must exist on NixOS (username/home 'visa' matches). /games and other mounts: ensure paths resolve."
echo "- Alternatively: re-pair phone <-> new PC in Syncthing UI and re-share folders (clean but more setup)."

if [ "$DO_BACKUP" = "1" ]; then
  echo
  warn "Creating SENSITIVE backup (contains key.pem/cert.pem/config). NEVER COMMIT."
  umask 077
  mkdir -p "$DEST"
  # stop syncthing first for a consistent backup? warn user; don't force-stop.
  if pgrep -x syncthing >/dev/null 2>&1; then
    warn "syncthing is running - for a consistent backup, consider stopping it first (backup proceeds anyway)."
  fi
  cp -a "$CFG/." "$DEST/"
  chmod -R go-rwx "$DEST" || true
  say "Backup written to: $DEST"
  warn "Review contents, store securely, and DELETE when no longer needed. Do NOT commit: $(realpath "$DEST" 2>/dev/null || echo "$DEST")"
fi

echo
say "Done (read-only info). Use --backup [DEST] to stage a local sensitive backup."